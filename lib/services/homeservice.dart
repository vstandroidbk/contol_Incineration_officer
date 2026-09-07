import 'package:contol_officer_app/API Service/apiClient.dart';
import 'package:contol_officer_app/API Service/apiUrls.dart';
import 'package:get/get.dart';

class MemberService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// 🔹 Get all officer members (full list, with real UUID)
Future<Map<String, dynamic>> getOfficerMembers() async {
  return await _apiClient.post(
    ApiUrls.getOfficerMembers, // same URL jo AllCustomersController use karta hai
    body: {
      "membershipId": "",
      "industryName": "",
    },
  );
}

  /// 🔹 Get officer's members filtered by pincode
  Future<Map<String, dynamic>> getOfficerMembersByPincode({
    required String pincode,
  }) async {
    return await _apiClient.post(
      ApiUrls.getOfficerMembersByPincode,
      body: {
        "pincode": pincode,
      },
    );
  }

/// 🔹 Get officer's category-wise summary (optionally filter by categoryTitle/categoryNumber)
Future<Map<String, dynamic>> getOfficerCategorySummary({
  String categoryTitle = "",
  String categoryNumber = "",
}) async {
  return await _apiClient.post(
    ApiUrls.getOfficerCategorySummary,
    body: {
      "categoryTitle": categoryTitle,
      "categoryNumber": categoryNumber,
    },
  );
}

/// 🔹 Get officer's members filtered by category
Future<Map<String, dynamic>> getOfficerMembersByCategory({
  required String categoryId,
}) async {
  return await _apiClient.post(
    ApiUrls.getOfficerMembersByCategory,
    body: {
      "categoryId": categoryId,
      "membershipId": "",
      "industryName": "",
    },
  );
}
}