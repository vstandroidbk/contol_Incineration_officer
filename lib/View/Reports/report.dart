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
  bool _isOpeningExportSheet = false;

  static const List<String> quarters = ["Q1", "Q2", "Q3", "Q4"];
  static const List<String> years = [
    "2023-24",
    "2024-25",
    "2025-26",
    "2026-27",
  ];

  @override
  void initState() {
    super.initState();
    controller.resetFilter();
  }

  void _handleExportTap() {
    if (_isOpeningExportSheet) return; // double-tap guard
    setState(() => _isOpeningExportSheet = true);

    openExportOptionsSheet(context, quarters: quarters, years: years);

    // 👈 sheet ka route push ho chuka hai (showModalBottomSheet synchronous
    // hai); ek frame render hone ka wait karo — tabhi sheet screen pe
    // dikhti hai — phir spinner hatao.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isOpeningExportSheet = false);
    });
  }

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
          onTap: _handleExportTap,
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: _isOpeningExportSheet
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
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
