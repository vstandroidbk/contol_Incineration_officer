import 'package:contol_officer_app/API%20Service/apiClient.dart';
import 'package:contol_officer_app/API%20Service/apiUrls.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:get/get.dart';

class ProfileService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// 🔹 Get logged-in officer's profile
  Future<Map<String, dynamic>> getOfficerProfile() async {
    return await _apiClient.post(ApiUrls.getOfficerProfile);
  }

  /// 🔹 Upload officer profile image
  /// loginUserId is auto-attached by ApiClient.postMultipart (attachUserId defaults true)
  Future<Map<String, dynamic>> uploadProfileImage({
    required String filePath,
  }) async {
    return await _apiClient.postMultipart(
      ApiUrls.uploadProfile,
      fields: {}, // no extra text fields needed — only the file
      files: {
        "officerProfile": [
          filePath,
        ], // 👈 must match Postman's file key exactly
      },
    );
  }

  Future<Map<String, dynamic>> editOfficerProfile({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String joiningDate,
  }) async {
    return await _apiClient.post(
      ApiUrls.editOfficerProfile,
      body: {
        "FullName": fullName,
        "Email": email,
        "mobileNumber": mobileNumber,
        "joiningDate": joiningDate,
      },
    );
  }

  /// 🔹 Update officer password
  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final String? userId = await AppSession.getUserId(); // 👈 fetch stored id

    return await _apiClient.post(
      ApiUrls.updatePassword,
      body: {
        "id":
            userId, // 👈 explicit "id" key — this endpoint needs "id", not "loginUserId"
        "currentPassword": currentPassword,
        "password": newPassword,
      },
    );
  }
}
