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
      body: {"userLoginDetail": userLoginDetail, "password": password},
    );
  }

  /// 🔹 Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String userLoginDetail,
    required String otp,
  }) async {
    final result = await _apiClient.post(
      ApiUrls.verifyOTP,
      attachUserId: false,
      body: {"userLoginDetail": userLoginDetail, "otp": otp},
    );

    if (result['status'] == "SUCCESS" && result['data'] != null) {
      final data = result['data'] as Map<String, dynamic>;

      final userId = data['officerId']?.toString() ?? "";

      if (userId.isNotEmpty) {
        await AppSession.saveUserId(userId);
        // Link OneSignal External ID
        try {
          //await OneSignal.login(userId);
          print("📩 OneSignal linked via OTP for ID: $userId");
        } catch (e) {
          print("❌ OneSignal OTP login failed: $e");
        }
      }
    }
    return result;
  }

  /// 🔹 Logout (Call this from your Profile/Settings)
  Future<void> logoutUser() async {
    try {
      //await OneSignal.logout();
      print("👋 OneSignal logout succeeded");
    } catch (e) {
      print("❌ OneSignal logout failed: $e");
    }
    await AppSession.logout();
  }

  // Forgot password
  Future<Map<String, dynamic>> forgotPswrd({
    required String userLoginDetail,
  }) async {
    return await _apiClient.post(
      ApiUrls.forgotpswrd,
      attachUserId: false,
      body: {"userLoginDetail": userLoginDetail},
    );
  }

  /// 🔹 Reset password
 Future<Map<String, dynamic>> resetPassword({
  required String userLoginDetail,
  required String password,
}) async {
  return await _apiClient.post(
    ApiUrls.resetPswrd,
    attachUserId: false,
    body: {
      "userLoginDetail": userLoginDetail,
      "newPassword": password,
    },
  );
}
}
