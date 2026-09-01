import 'package:contol_officer_app/API Service/apiClient.dart';
import 'package:contol_officer_app/API Service/apiUrls.dart';
import 'package:get/get.dart';

class ReportService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Map<String, dynamic>> getRegionalWasteCategorySummary({
    int? year,
    int? quarter,
  }) async {
    return await _apiClient.post(
      ApiUrls.viewWasteCategory,
      body: {
        "year": year ?? "",
        "quarter": quarter ?? "",
      },
    );
  }

  /// 🔹 Generate a member waste-usage PDF report, filtered by member/year/quarter.
  /// Any filter left null/omitted is treated as "ALL" by the backend.
  Future<Map<String, dynamic>> generateMemberWasteReport({
    String? memberId,
    int? year,
    int? quarter,
  }) async {
    return await _apiClient.post(
      ApiUrls.generateMemberWasteReport,
      body: {
        "memberId": memberId ?? "",
        "year": year ?? "",
        "quarter": quarter ?? "",
      },
    );
  }
}