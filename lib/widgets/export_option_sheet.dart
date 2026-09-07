import 'package:contol_officer_app/Controller/customerController.dart';
import 'package:contol_officer_app/Controller/reportsController.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/file_preview.dart';
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

  String? selectedYear = _currentFinancialYearLabel(years);

  reportController.previewedReport.value = null;
  reportController.checkStatusMessage.value = '';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          Future<void> checkAndViewPdf() async {
            await reportController.checkReportAvailability(
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

            final report = reportController.previewedReport.value;
            if (report != null) {
              Navigator.pop(sheetContext);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PdfViewScreen(
                    pdfUrl: report.pdfUrl,
                    title: report.pdfFileName.isNotEmpty
                        ? report.pdfFileName
                        : 'Waste Report',
                    showDownload: true,
                  ),
                ),
              );
            }
          }

          return Container(
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(context).viewInsets.bottom +
                  MediaQuery.of(context).padding.bottom +
                  16,
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

                    const String allMembersLabel = "All Members";
                    final memberNames = [
                      allMembersLabel,
                      ...customersController.allMembers.map(
                        (m) => m.industryName,
                      ),
                    ];

                    return CustomDropdownField2(
                      label: "Member ",
                      hintText: "All members",
                      value: selectedMemberLabel ?? allMembersLabel,
                      items: memberNames,
                      searchable: true,
                      onChanged: (v) {
                        // ✅ CHANGED — local state only, no API call here
                        setSheetState(() {
                          if (v == allMembersLabel) {
                            selectedMemberLabel = null;
                            selectedMemberId = null;
                          } else {
                            selectedMemberLabel = v;
                            final match = customersController.allMembers
                                .firstWhereOrNull((m) => m.industryName == v);
                            selectedMemberId = match?.membershipId;
                          }
                          // stale preview/error no longer matches the new
                          // filter selection — clear so old banner doesn't
                          // mislead the user until they check again
                          reportController.previewedReport.value = null;
                          reportController.checkStatusMessage.value = '';
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 18),

                  // ── Quarter ──────────────────────────
                  const Text(
                    "Quarter ",
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
                          // ✅ CHANGED — local state only, no API call here
                          setSheetState(() {
                            selectedQuarter = isSelected ? null : q;
                            reportController.previewedReport.value = null;
                            reportController.checkStatusMessage.value = '';
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  // ── Year ──────────────────────────
                  const Text(
                    "Year ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bodytextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  YearPickerField(
                    value: selectedYear, // ab pre-filled current FY hoga
                    hintText: "All years",
                    onChanged: (v) {
                      setSheetState(() {
                        selectedYear = v;
                        reportController.previewedReport.value = null;
                        reportController.checkStatusMessage.value = '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Live status: only reflects the LAST time
                  // "View PDF" was pressed — not every filter tweak.
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

                  // ── View PDF button — now triggers the check itself ──
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      final isChecking =
                          reportController.isCheckingReport.value;

                      return ElevatedButton.icon(
                        // ✅ CHANGED — always tappable (unless a check is
                        // already in flight); the button itself now runs
                        // the availability check, then navigates on success
                        onPressed: isChecking ? null : () => checkAndViewPdf(),
                        icon: isChecking
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                LucideIcons.eye,
                                color: Colors.white,
                                size: 18,
                              ),
                        label: Text(
                          isChecking ? "Checking..." : "View PDF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary
                              .withOpacity(0.6),
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

/// Computes the current Indian financial year label ("YYYY-YY") to
/// preselect in the Year dropdown. Financial year runs Apr 1 – Mar 31,
/// so Jan–Mar counts toward the year that started the previous April.
/// Returns null if that computed label isn't present in `years` (so the
/// dropdown safely falls back to "All years" rather than showing a value
/// that doesn't exist in its item list).
String? _currentFinancialYearLabel(List<String> years) {
  final now = DateTime.now();
  final startYear = now.month >= 4 ? now.year : now.year - 1;
  final endYearShort = (startYear + 1).toString().substring(2);
  final label = "$startYear-$endYearShort"; // e.g. "2026-27"

  return years.contains(label) ? label : null;
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
