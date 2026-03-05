import 'package:contol_officer_app/API%20Service/apiUrls.dart';
import 'package:contol_officer_app/API%20Service/networkHelper.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:contol_officer_app/utils/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class ApiClient extends GetxService {
  late Dio dio;

  // ✅ Global flag — prevents duplicate "no internet" snackbars
  // when multiple APIs fire simultaneously (e.g. home screen init)
  static DateTime? _lastNoInternetSnackbar;

  Future<ApiClient> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("➡️ ${options.method} ${options.uri}");
          print("Headers: ${options.headers}");
          print("Body: ${options.data}");
          handler.next(options);
        },
        onResponse: (response, handler) {
          print("⬅️ Response: ${response.data}");
          handler.next(response);
        },
        onError: (error, handler) {
          print("❌ RAW API ERROR: ${error.message}");
          handler.next(error);
        },
      ),
    );

    return this;
  }

  /// ✅ Show snackbar at most once every 4 seconds globally
  /// Prevents snackbar spam when 5+ APIs fail simultaneously offline
  static void _showNoInternetOnce() {
    final now = DateTime.now();
    if (_lastNoInternetSnackbar == null ||
        now.difference(_lastNoInternetSnackbar!).inSeconds >= 4) {
      _lastNoInternetSnackbar = now;
      AppSnackBar.error(message: "No internet connection.");
    }
  }

  /// ✅ Normal POST
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool useToken = true,
    bool attachUserId = true,
  }) async {
    try {
      /// 1️⃣ Internet check
      final hasInternet = await NetworkHelper.hasInternet();
      if (!hasInternet) {
        // ✅ Show snackbar globally — throttled to avoid spam
        _showNoInternetOnce();
        return {
          "status": "FAILURE",
          "message": "No internet connection.",
          "data": null,
        };
      }

      /// 2️⃣ Prepare headers
      Map<String, dynamic> headers = {"Content-Type": "application/json"};

      if (useToken) {
        String? token = await AppSession.getToken();
        if (token != null && token.isNotEmpty) {
          headers["Authorization"] = "Bearer $token";
        }
      }

      /// 3️⃣ Prepare body
      String? playerId = await AppSession.getPlayerId();
      String? userId;

      if (attachUserId) {
        userId = await AppSession.getUserId();
      }

      final data = {
        "env_type": ApiUrls.envType,
        "onesignal_player_id": playerId,
        if (userId != null) "loginUserId": userId,
        ...?body,
      };

      /// 4️⃣ Make request
      final response = await dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );

      return {
        "status": response.data["status"],
        "message": response.data["message"],
        "data": response.data["data"],
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      print("❌ UNKNOWN ERROR: $e");
      return {
        "status": "FAILURE",
        "message": "Something went wrong.",
        "data": null,
      };
    }
  }

  /// ✅ Multipart POST
  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
    Map<String, List<String>>? files,
    bool attachUserId = true,
  }) async {
    try {
      final hasInternet = await NetworkHelper.hasInternet();
      if (!hasInternet) {
        _showNoInternetOnce();
        return {
          "status": "FAILURE",
          "message": "No internet connection.",
          "data": null,
        };
      }

      String? userId;
      if (attachUserId) {
        userId = await AppSession.getUserId();
      }

      final formData = FormData();

      formData.fields.add(MapEntry("env_type", ApiUrls.envType));

      if (userId != null) {
        formData.fields.add(MapEntry("loginUserId", userId));
      }

      fields.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      if (files != null) {
        for (final entry in files.entries) {
          for (final path in entry.value) {
            if (path.isNotEmpty && !path.startsWith('http')) {
              formData.files.add(
                MapEntry(entry.key, await MultipartFile.fromFile(path)),
              );
            }
          }
        }
      }

      final response = await dio.post(
        endpoint,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      return {
        "status": response.data["status"],
        "message": response.data["message"],
        "data": response.data["data"],
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      print("❌ MULTIPART UNKNOWN ERROR: $e");
      return {
        "status": "FAILURE",
        "message": "Something went wrong.",
        "data": null,
      };
    }
  }

  /// ✅ Centralized Error Handler
  Map<String, dynamic> _handleDioError(DioException e) {
    String errorMessage = "Something went wrong.";

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = "Server is not responding. Please try again.";
        AppSnackBar.error(message: errorMessage);
        break;

      case DioExceptionType.connectionError:
        errorMessage = "No internet connection.";
        _showNoInternetOnce();
        break;

      case DioExceptionType.badResponse:
        errorMessage = e.response?.data?['message'] ?? "Server error occurred.";
        break;

      case DioExceptionType.cancel:
        errorMessage = "Request was cancelled.";
        break;

      default:
        errorMessage = "Unexpected error occurred.";
    }

    print("❌ CLEAN ERROR: $errorMessage");

    return {"status": "FAILURE", "message": errorMessage, "data": null};
  }
}