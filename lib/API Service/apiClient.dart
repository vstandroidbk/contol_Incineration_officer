import 'package:contol_officer_app/API%20Service/apiUrls.dart';
import 'package:contol_officer_app/API%20Service/networkHelper.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:contol_officer_app/utils/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart' hide FormData, MultipartFile;

class ApiClient extends GetxService {
  late Dio dio;

  static DateTime? _lastNoInternetSnackbar;

  // ✅ NEW: in-flight request de-duplication
  // Agar same endpoint+body wali request already pending hai, naya call mat karo —
  // existing Future ka result return kar do. Ye "get-Officer-notifications 2x call"
  // jaisa pattern globally rok dega, chahe wo kisi bhi screen se trigger ho.
  static final Map<String, Future<Map<String, dynamic>>> _pendingRequests = {};

  Future<ApiClient> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.liveUrl,
        // ⬇️ CHANGED: 30s -> 12s. 30s matlab user 30 second tak "hang" dekh sakta hai
        // bina kisi feedback ke. Mobile network pe agar 12s me response nahi aaya,
        // usually aage bhi nahi aayega — fail fast better hai.
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
        headers: {
          "Content-Type": "application/json",
          // ✅ NEW: server agar gzip support karta hai to response size
          // 60-80% tak chhota ho sakta hai — bina kisi aur change ke.
          "Accept-Encoding": "gzip",
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // ⬇️ CHANGED: sirf debug build me print hoga, release me nahi
          if (kDebugMode) {
            print("➡️ ${options.method} ${options.uri}");
            print("Body: ${options.data}");
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print("⬅️ Response: ${response.data}");
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print("❌ RAW API ERROR: ${error.message}");
          }
          handler.next(error);
        },
      ),
    );

    return this;
  }

  static void _showNoInternetOnce() {
    final now = DateTime.now();
    if (_lastNoInternetSnackbar == null ||
        now.difference(_lastNoInternetSnackbar!).inSeconds >= 4) {
      _lastNoInternetSnackbar = now;
      AppSnackBar.error(message: "No internet connection.");
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool useToken = true,
    bool attachUserId = true,
  }) async {
    // ✅ NEW: de-dup key — same endpoint + same body = same in-flight request
    final dedupeKey = "$endpoint|${body?.toString() ?? ''}";
    if (_pendingRequests.containsKey(dedupeKey)) {
      if (kDebugMode) print("♻️ Reusing in-flight request: $dedupeKey");
      return _pendingRequests[dedupeKey]!;
    }

    final future = _postInternal(endpoint, body: body, useToken: useToken, attachUserId: attachUserId);
    _pendingRequests[dedupeKey] = future;

    try {
      return await future;
    } finally {
      _pendingRequests.remove(dedupeKey);
    }
  }

  Future<Map<String, dynamic>> _postInternal(
    String endpoint, {
    Map<String, dynamic>? body,
    bool useToken = true,
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

      Map<String, dynamic> headers = {"Content-Type": "application/json"};

      // ⬇️ CHANGED: teeno reads ab parallel me chalte hain, sequential nahi
      final results = await Future.wait([
        useToken ? AppSession.getToken() : Future.value(null),
        AppSession.getPlayerId(),
        attachUserId ? AppSession.getUserId() : Future.value(null),
      ]);
      final token = results[0];
      final playerId = results[1];
      final userId = results[2];

      if (useToken && token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final data = {
        "env_type": ApiUrls.envType,
        "onesignal_player_id": playerId,
        if (userId != null) "loginUserId": userId,
        ...?body,
      };

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
      if (kDebugMode) print("❌ UNKNOWN ERROR: $e");
      return {
        "status": "FAILURE",
        "message": "Something went wrong.",
        "data": null,
      };
    }
  }

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
      if (kDebugMode) print("❌ MULTIPART UNKNOWN ERROR: $e");
      return {
        "status": "FAILURE",
        "message": "Something went wrong.",
        "data": null,
      };
    }
  }

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

    if (kDebugMode) print("❌ CLEAN ERROR: $errorMessage");

    return {"status": "FAILURE", "message": errorMessage, "data": null};
  }
}