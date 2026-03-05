import 'package:contol_officer_app/services/Auth/authService.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  var isComplete = false.obs;
  var userId = "".obs;
  var kycStatus = 0.obs;

  /// 🔐 Login API
  Future<Map<String, dynamic>> login({
    required String userLoginDetail,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final res = await _authService.login(
        userLoginDetail: userLoginDetail,
        password: password,
      );

      // ✅ Update state only on success
      if (res["status"] == "SUCCESS" && res["data"] != null) {
        final String id = res["data"]["officerId"] ?? "";
        userId.value = id;

        //user id save
        await AppSession.saveUserId(id);
        // ✅ Re-subscribe to push notifications for this user
        // OneSignal.login(userId.trim());
        // OneSignal.User.pushSubscription.optIn();

        // 🖨️ DEBUG LOGS
        print("✅ LOGIN SUCCESS");
        print("🆔 User ID saved: $id");

        // Verify from storage
        final storedId = await AppSession.getUserId();
        print("📦 Stored User ID (from prefs): $storedId");
      }

      //  UI will handle success / error
      return res;
    } catch (e) {
      return {
        "status": "FAILURE",
        "message": "Something went wrong. Please try again.",
        "data": null,
      };
    } finally {
      isLoading.value = false;
    }
  }

  /// forgot password
  Future<Map<String, dynamic>> forgotPswrd(String userLoginDetail) async {
    try {
      isLoading.value = true;

      final res = await _authService.forgotPswrd(userLoginDetail: userLoginDetail);

      // 🔍 Debug log
      print("📨 SEND OTP RESPONSE: $res");

      return res;
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔐 Verify OTP API
  Future<Map<String, dynamic>> verifyOtp({
    required String userLoginDetail,
    required String otp,
  }) async {
    try {
      isLoading.value = true;

      final res = await _authService.verifyOtp(userLoginDetail: userLoginDetail, otp: otp);

      // 🖨️ DEBUG LOGS
      print("🔐 VERIFY OTP RESPONSE: $res");

      return res;
    } catch (e) {
      print("❌ VERIFY OTP ERROR: $e");
      return {
        "status": "FAILURE",
        "message": "Something went wrong. Please try again.",
        "data": null,
      };
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔐 Reset Password API
  Future<Map<String, dynamic>> resetPassword({
    required String userloginDetail,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final res = await _authService.resetPassword(
        userLoginDetail: userloginDetail,
        password: password,
      );

      // 🖨️ DEBUG LOGS
      print("🔁 RESET PASSWORD RESPONSE: $res");

      return res;
    } catch (e) {
      print("❌ RESET PASSWORD ERROR: $e");
      return {
        "status": "FAILURE",
        "message": "Something went wrong. Please try again.",
        "data": null,
      };
    } finally {
      isLoading.value = false;
    }
  }
}
