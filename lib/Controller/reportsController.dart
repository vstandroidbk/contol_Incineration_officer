import 'dart:async';
import 'package:contol_officer_app/model/reportsModel.dart';
import 'package:contol_officer_app/services/reportServices.dart';
import 'package:contol_officer_app/utils/file_download.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  final ReportService _reportService = ReportService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var apiMessage = ''.obs;

  var wasteCategoryReport = Rxn<WasteCategoryReportModel>();

  var selectedYear = Rxn<int>();
  var selectedQuarter = Rxn<int>();
  var selectedYearLabel = Rxn<String>();
  var selectedQuarterLabel = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchWasteCategoryReport();
  }

  Future<void> fetchWasteCategoryReport({
    int? year,
    int? quarter,
    String? yearLabel,
    String? quarterLabel,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedYear.value = year;
      selectedQuarter.value = quarter;
      selectedYearLabel.value = yearLabel;
      selectedQuarterLabel.value = quarterLabel;

      final res = await _reportService.getRegionalWasteCategorySummary(
        year: year,
        quarter: quarter,
      );

      apiMessage.value = res["message"]?.toString() ?? '';

      if (res["status"] == "SUCCESS" && res["data"] != null) {
        wasteCategoryReport.value = WasteCategoryReportModel.fromJson(res["data"]);
      } else {
        wasteCategoryReport.value = null;
        errorMessage.value = res["message"] ?? "Something went wrong.";
      }
    } catch (e) {
      wasteCategoryReport.value = null;
      apiMessage.value = '';
      errorMessage.value = "Something went wrong. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetFilter() => fetchWasteCategoryReport();

  // ─────────────────────────────────────────────────────────────
  // 🔹 Export-sheet flow: check availability → cache result → download
  // ─────────────────────────────────────────────────────────────

  Timer? _checkDebounce;

  /// Whether a check request is currently in flight.
  var isCheckingReport = false.obs;

  /// The last successfully generated report — non-null means "ready to download".
  var previewedReport = Rxn<WasteReportGenerateModel>();

  /// Message to show when the current filter combo has no data / errored.
  /// Empty string = no problem to show.
  var checkStatusMessage = ''.obs;

  /// Whether the download itself is running (separate from the check).
  var isDownloading = false.obs;

  /// Call this every time a filter changes in the sheet. Debounced so rapid
  /// chip/dropdown taps don't fire a request per tap.
  void onFilterChanged({
    String? memberId,
    int? year,
    int? quarter,
  }) {
    // Any change invalidates the last successful result immediately —
    // keeps the Export button disabled until the new combo is confirmed.
    previewedReport.value = null;
    checkStatusMessage.value = '';

    _checkDebounce?.cancel();
    _checkDebounce = Timer(const Duration(milliseconds: 500), () {
      _checkReportAvailability(memberId: memberId, year: year, quarter: quarter);
    });
  }

  Future<void> _checkReportAvailability({
    String? memberId,
    int? year,
    int? quarter,
  }) async {
    try {
      isCheckingReport.value = true;
      checkStatusMessage.value = '';

      final res = await _reportService.generateMemberWasteReport(
        memberId: memberId,
        year: year,
        quarter: quarter,
      );

      if (res["status"] == "SUCCESS" && res["data"] != null) {
        previewedReport.value = WasteReportGenerateModel.fromJson(res["data"]);
        checkStatusMessage.value = '';
      } else {
        previewedReport.value = null;
        checkStatusMessage.value =
            res["message"]?.toString() ?? "No data found for the selected filters.";
      }
    } catch (e) {
      previewedReport.value = null;
      checkStatusMessage.value = "Something went wrong. Please try again.";
    } finally {
      isCheckingReport.value = false;
    }
  }

  /// Downloads the already-generated PDF from the last successful check.
  /// Does NOT call the generate API again — reuses the cached pdfUrl.
  /// `context` must belong to a widget that stays mounted for the duration
  /// of this call (e.g. the still-open bottom sheet) so snackbars/dialogs
  /// inside the download helper resolve safely.
  Future<void> downloadPreviewedReport(BuildContext context) async {
    final report = previewedReport.value;
    if (report == null || report.pdfUrl.isEmpty) return;

    try {
      isDownloading.value = true;

      await FileDownloadHelper.downloadFile(
        context: context,
        fileUrl: report.pdfUrl,
        customFileName: report.pdfFileName.isNotEmpty ? report.pdfFileName : null,
        displayName: 'Waste Report',
      );
    } finally {
      isDownloading.value = false;
    }
  }

  @override
  void onClose() {
    _checkDebounce?.cancel();
    super.onClose();
  }
}