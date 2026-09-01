import 'package:contol_officer_app/API Service/apiClient.dart';
import 'package:contol_officer_app/API Service/apiUrls.dart';
import 'package:get/get.dart';

class AllMembersService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// 🔹 Get all officer members (with optional membershipId / industryName filters)
  Future<Map<String, dynamic>> getOfficerMembers({
    String membershipId = "",
    String industryName = "",
  }) async {
    return await _apiClient.post(
      ApiUrls.getOfficerMembers,
      body: {"membershipId": membershipId, "industryName": industryName},
    );
  }

  /// 🔹 Get membership years & quarters for a specific member
  Future<Map<String, dynamic>> getMembershipYears({
    required String memberId,
  }) async {
    return await _apiClient.post(
      ApiUrls.getMembershipYears,
      body: {"memberId": memberId},
    );
  }

  /// 🔹 Get member's category-wise waste summary (optionally filtered by year/quarter)
  Future<Map<String, dynamic>> getMemberWasteCategory({
    required String memberId,
    int? year,
    int? quarter,
  }) async {
    return await _apiClient.post(
      ApiUrls.viewMemberWasteCategory,
      body: {
        "memberId": memberId,
        "year": year ?? "",
        "quarter": quarter ?? "",
      },
    );
  }
}
