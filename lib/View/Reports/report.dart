import 'package:contol_officer_app/Controller/reportsController.dart';
import 'package:contol_officer_app/View/Reports/waste_cat_report.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/widgets/export_option_sheet.dart';
import 'package:contol_officer_app/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final ReportController controller = Get.put(ReportController());

  // Same static data used by export sheet
  static const List<String> memberNames = [
    "Medical Center A",
    "Green Energy Co",
    "ABC Industries",
    "Sunrise Pharma",
    "BlueSky Logistics",
    "Nashik Textiles",
  ];
  static const List<String> quarters = ["Q1", "Q2", "Q3", "Q4"];
  static const List<String> years = [
    "2023-24",
    "2024-25",
    "2025-26",
    "2026-27",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        title: "Reports",
        subtitle: "Waste Usage analytics for your district",
        rightWidget: InkWell(
          onTap: () {
            openExportOptionsSheet(
              context,
              //memberNames: memberNames,
              quarters: quarters,
              years: years,
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              LucideIcons.download,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
      body: Obx(
        () => LoaderWrapper(
          isLoading: controller.isLoading.value,
          shimmerItems: 10,
          showCard: true,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: WasteCategoriesReport(controller: controller),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
