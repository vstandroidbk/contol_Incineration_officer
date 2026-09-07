import 'package:contol_officer_app/Controller/reportsController.dart';
import 'package:contol_officer_app/View/Reports/waste_cat_report_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WasteCategoriesReport extends StatelessWidget {
  final ReportController controller;

  const WasteCategoriesReport({super.key, required this.controller});

  static const List<String> quarters = ["Q1", "Q2", "Q3", "Q4"];

  // "2023-24" -> 2023 | null -> null (ALL)
  int? _parseYear(String? y) {
    if (y == null) return null;
    return int.tryParse(y.split('-').first);
  }

  // "Q1" -> 1 | null -> null (ALL)
  int? _parseQuarter(String? q) {
    if (q == null) return null;
    return int.tryParse(q.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final report = controller.wasteCategoryReport.value;
      final items = report?.response ?? [];

      final categories = items
          .map(
            (c) => {
              "title": c.categoryTitle,
              "number": c.categoryNumber,
              "authorized": c.totalAllocated,
              "used": c.totalUsed,
              "unit": c.allocatedQuantityType,
              "active": true, // API doesn't return this — default active
              "memberName": null, // aggregated per category, not per member
            },
          )
          .toList();

      final emptyMessage = controller.errorMessage.value.isNotEmpty
          ? controller.errorMessage.value
          : (controller.apiMessage.value.isNotEmpty
                ? controller.apiMessage.value
                : "No waste category data found.");

      return WasteCategoryReportSection(
        title: "All Waste Categories",
        subtitle: "Usage across every member in your district",
        categories: categories,
        quarters: quarters,
        totalCount: categories.length,
        emptyMessage: emptyMessage,
        // Read from controller (not local widget state) — this is what
        // survives LoaderWrapper's shimmer swap and keeps the chip visible.
        selectedYear: controller.selectedYearLabel.value,
        selectedQuarter: controller.selectedQuarterLabel.value,
        onFilterChanged: (year, quarter) {
          controller.fetchWasteCategoryReport(
            year: _parseYear(year),
            quarter: _parseQuarter(quarter),
            yearLabel: year,
            quarterLabel: quarter,
          );
        },
      );
    });
  }
}
