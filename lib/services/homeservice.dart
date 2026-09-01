import 'package:contol_officer_app/API Service/apiClient.dart';
import 'package:contol_officer_app/API Service/apiUrls.dart';
import 'package:get/get.dart';

class MemberService {
  final ApiClient _apiClient = Get.find<ApiClient>();

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
}