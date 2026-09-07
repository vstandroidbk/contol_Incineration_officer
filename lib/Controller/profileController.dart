import 'package:contol_officer_app/model/profilemodel.dart';
import 'package:contol_officer_app/services/Auth/profileService.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  var isLoading = false.obs;
  var isUploadingImage = false.obs;
  var isUpdatingProfile = false.obs; // 👈 new
  var officerProfile = Rxn<OfficerProfileModel>();

    var isChangingPassword = false.obs; // 👈 new

  /// 🔹 Change officer password
  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isChangingPassword.value = true;

      final res = await _profileService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      print("🔐 UPDATE PASSWORD RESPONSE: $res");
      return res;
    } catch (e) {
      print("❌ UPDATE PASSWORD ERROR: $e");
      return {
        "status": "FAILURE",
        "message": "Something went wrong. Please try again.",
        "data": null,
      };
    } finally {
      isChangingPassword.value = false;
    }
  }

  Future<void> fetchOfficerProfile() async {
    try {
      isLoading.value = true;
      final res = await _profileService.getOfficerProfile();
      print("👤 GET PROFILE RESPONSE: $res");

      if (res["status"] == "SUCCESS" && res["data"] != null) {
        officerProfile.value = OfficerProfileModel.fromJson(res["data"]);
      }
    } catch (e) {
      print("❌ PROFILE FETCH ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> uploadProfileImage(String filePath) async {
    try {
      isUploadingImage.value = true;
      final res = await _profileService.uploadProfileImage(filePath: filePath);
      print("📷 UPLOAD PROFILE IMAGE RESPONSE: $res");

      if (res["status"] == "SUCCESS" && res["data"] != null) {
        final String? newImageUrl = res["data"]["profileImage"];
        if (newImageUrl != null && officerProfile.value != null) {
          officerProfile.value = officerProfile.value!.copyWith(
            profile: newImageUrl,
          );
        }
      }
      return res;
    } catch (e) {
      print("❌ UPLOAD PROFILE IMAGE ERROR: $e");
      return {
        "status": "FAILURE",
        "message": "Something went wrong. Please try again.",
        "data": null,
      };
    } finally {
      isUploadingImage.value = false;
    }
  }

  /// 🔹 Edit officer profile details
  Future<Map<String, dynamic>> editOfficerProfile({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String joiningDate,
  }) async {
    try {
      isUpdatingProfile.value = true;

      final res = await _profileService.editOfficerProfile(
        fullName: fullName,
        email: email,
        mobileNumber: mobileNumber,
        joiningDate: joiningDate,
      );

      print("✏️ EDIT PROFILE RESPONSE: $res");

      // ✅ Update local state instantly on success — no refetch needed
      if (res["status"] == "SUCCESS" &&
          res["data"] != null &&
          officerProfile.value != null) {
        final data = res["data"];
        officerProfile.value = officerProfile.value!.copyWith(
          fullName: data["FullName"],
          email: data["Email"],
          mobileNumber: data["mobileNumber"],
          joiningDate: data["joiningDate"],
        );
      }

      return res;
    } catch (e) {
      print("❌ EDIT PROFILE ERROR: $e");
      return {
        "status": "FAILURE",
        "message": "Something went wrong. Please try again.",
        "data": null,
      };
    } finally {
      isUpdatingProfile.value = false;
    }
  }
}
