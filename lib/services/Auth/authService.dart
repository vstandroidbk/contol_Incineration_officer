import 'package:contol_officer_app/API%20Service/apiClient.dart';
import 'package:contol_officer_app/API%20Service/apiUrls.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:get/get.dart';

class AuthService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// 🔹 Login API
  Future<Map<String, dynamic>> login({
    required String userLoginDetail,
    required String password,
  }) async {
    return await _apiClient.post(
      ApiUrls.login,
      attachUserId: false,
      body: {"userLoginId": userLoginDetail, "password": password}, // ✅ fixed key
    );
  }

  /// 🔹 Send OTP (forgot password step 1)
  Future<Map<String, dynamic>> forgotPswrd({
    required String userLoginDetail,
  }) async {
    return await _apiClient.post(
      ApiUrls.forgotpswrd,
      attachUserId: false,
      body: {"userEmail": userLoginDetail}, // ✅ fixed key
    );
  }

  /// 🔹 Verify OTP (forgot password step 2)
  /// Returns the reset token ("id") in result['data']['id'] — NOT a login session.
  /// Do NOT save this into AppSession — it's unrelated to the logged-in user.
  Future<Map<String, dynamic>> verifyOtp({
    required String userLoginDetail,
    required String otp,
  }) async {
    return await _apiClient.post(
      ApiUrls.verifyOTP,
      attachUserId: false,
      body: {"userEmail": userLoginDetail, "otp": otp}, // ✅ fixed key
    );
  }

  /// 🔹 Reset password (forgot password step 3)
  /// Takes the reset token "id" from verify-otp's response — not the email.
  Future<Map<String, dynamic>> resetPassword({
    required String id,
    required String password,
  }) async {
    return await _apiClient.post(
      ApiUrls.resetPswrd,
      attachUserId: false,
      body: {"id": id, "password": password}, // ✅ fixed keys
    );
  }

  /// 🔹 Logout
  Future<void> logoutUser() async {
    try {
      print("👋 OneSignal logout succeeded");
    } catch (e) {
      print("❌ OneSignal logout failed: $e");
    }
    await AppSession.logout();
  }
}