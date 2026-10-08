import 'package:contol_officer_app/services/Auth/authService.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
        await _linkOneSignal(id);

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

  /// 🔔 Link OneSignal to the logged-in officer + persist push subscription id
  Future<void> _linkOneSignal(String id) async {
    try {
      if (id.isEmpty) return;

      OneSignal.login(id.trim());
      OneSignal.User.pushSubscription.optIn();

      final pushId = OneSignal.User.pushSubscription.id;
      if (pushId != null && pushId.isNotEmpty) {
        await AppSession.savePlayerId(pushId);
        print("🚀 OneSignal linked — User: $id, Push ID: $pushId");
      } else {
        // Push id not ready yet (subscription still registering) —
        // add a one-time observer so we capture it as soon as it arrives.
        OneSignal.User.pushSubscription.addObserver((state) {
          final lateId = OneSignal.User.pushSubscription.id;
          if (lateId != null && lateId.isNotEmpty) {
            AppSession.savePlayerId(lateId);
            print("🚀 OneSignal push ID captured late: $lateId");
          }
        });
      }
    } catch (e) {
      print("❌ OneSignal link error: $e");
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
    required String id,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final res = await _authService.resetPassword(
        id: id,
        password: password,
      );

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