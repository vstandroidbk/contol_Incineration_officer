import 'package:contol_officer_app/Controller/customerController.dart';
import 'package:contol_officer_app/Controller/reportsController.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/year_picker.dart';
import 'package:contol_officer_app/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

void openExportOptionsSheet(
  BuildContext context, {
  required List<String> quarters,
  required List<String> years,
}) {
  final AllCustomersController customersController =
      Get.isRegistered<AllCustomersController>()
      ? Get.find<AllCustomersController>()
      : Get.put(AllCustomersController());

  final ReportController reportController = Get.find<ReportController>();

  if (customersController.allMembers.isEmpty) {
    customersController.fetchAllMembers();
  }

  String? selectedMemberId;
  String? selectedMemberLabel;
  String? selectedQuarter;
  String? selectedYear;

  // Fire an initial check for "no filters = all data" as soon as the sheet opens.
  reportController.onFilterChanged();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          void triggerCheck() {
            reportController.onFilterChanged(
              memberId: selectedMemberId,
              year: selectedYear == null
                  ? null
                  : int.tryParse(selectedYear!.split('-').first),
              quarter: selectedQuarter == null
                  ? null
                  : int.tryParse(
                      selectedQuarter!.replaceAll(RegExp(r'[^0-9]'), ''),
                    ),
            );
          }

          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.textfieldBorder,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const Text(
                    "Export Usage Report",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bodytextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Filter by member, quarter, or year — leave any blank to include all",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lighttextColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Member ──────────────────────────
                  Obx(() {
                    if (customersController.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          ),
                        ),
                      );
                    }

                    if (customersController.errorMessage.value.isNotEmpty &&
                        customersController.allMembers.isEmpty) {
                      return Text(
                        customersController.errorMessage.value,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }

                    final memberNames = customersController.allMembers
                        .map((m) => m.industryName)
                        .toList();

                    return CustomDropdownField2(
                      label: "Member (optional)",
                      hintText: "All members",
                      value: selectedMemberLabel,
                      items: memberNames,
                      searchable: true,
                      onChanged: (v) {
                        setSheetState(() {
                          selectedMemberLabel = v;
                          final match = customersController.allMembers
                              .firstWhereOrNull((m) => m.industryName == v);
                          selectedMemberId = match?.membershipId;
                        });
                        triggerCheck();
                      },
                    );
                  }),

                  const SizedBox(height: 18),

                  // ── Quarter ──────────────────────────
                  const Text(
                    "Quarter (optional)",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bodytextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: quarters.map((q) {
                      final isSelected = selectedQuarter == q;
                      return _Chip(
                        label: q,
                        selected: isSelected,
                        onTap: () {
                          setSheetState(
                            () => selectedQuarter = isSelected ? null : q,
                          );
                          triggerCheck();
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  // ── Year ──────────────────────────
                  const Text(
                    "Year (optional)",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bodytextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  YearPickerField(
                    value: selectedYear,
                    hintText: "All years",
                    onChanged: (v) {
                      setSheetState(() => selectedYear = v);
                      triggerCheck();
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Live status: checking / ready / no-data ──────────────
                  Obx(() {
                    if (reportController.isCheckingReport.value) {
                      return _StatusBanner(
                        icon: LucideIcons.loader,
                        iconColor: AppColors.primary,
                        text: "Checking availability...",
                        background: AppColors.primary.withOpacity(0.06),
                        spinning: true,
                      );
                    }

                    final report = reportController.previewedReport.value;
                    if (report != null) {
                      return _StatusBanner(
                        icon: LucideIcons.checkCircle2,
                        iconColor: Colors.green.shade600,
                        text:
                            "Report ready — ${report.memberCount} member${report.memberCount == 1 ? '' : 's'} found",
                        background: Colors.green.withOpacity(0.07),
                      );
                    }

                    final msg = reportController.checkStatusMessage.value;
                    if (msg.isNotEmpty) {
                      return _StatusBanner(
                        icon: LucideIcons.alertCircle,
                        iconColor: Colors.red.shade600,
                        text: msg,
                        background: Colors.red.withOpacity(0.06),
                      );
                    }

                    return const SizedBox.shrink();
                  }),

                  const SizedBox(height: 20),

                  // ── Export button ──────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      final canExport =
                          reportController.previewedReport.value != null &&
                          !reportController.isCheckingReport.value &&
                          !reportController.isDownloading.value;

                      return ElevatedButton.icon(
                        onPressed: canExport
                            ? () async {
                                // Download BEFORE popping — the sheet's own
                                // context stays mounted for the whole call,
                                // so snackbars/dialogs inside the download
                                // helper never hit a deactivated widget.
                                await reportController.downloadPreviewedReport(
                                  sheetContext,
                                );
                                if (sheetContext.mounted) {
                                  Navigator.pop(sheetContext);
                                }
                              }
                            : null,
                        icon: reportController.isDownloading.value
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
                        label: Text(
                          reportController.isDownloading.value
                              ? "Downloading..."
                              : "Export PDF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary
                              .withOpacity(0.35),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _StatusBanner extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color background;
  final String text;
  final bool spinning;

  const _StatusBanner({
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.text,
    this.spinning = false,
  });

  @override
  State<_StatusBanner> createState() => _StatusBannerState();
}

class _StatusBannerState extends State<_StatusBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: widget.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          widget.spinning
              ? RotationTransition(
                  turns: _controller,
                  child: Icon(widget.icon, size: 16, color: widget.iconColor),
                )
              : Icon(widget.icon, size: 16, color: widget.iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: widget.iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.textfieldBorder,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.bodytextColor,
          ),
        ),
      ),
    );
  }
}
