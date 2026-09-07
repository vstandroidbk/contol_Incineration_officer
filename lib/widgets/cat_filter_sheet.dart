import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/year_picker.dart';
import 'package:flutter/material.dart';

/// Reusable Year + Quarter filter bottom sheet.
/// Used in Reports (all members) — years are picked via a modern calendar-style
/// year picker (any year selectable, not a fixed list). Quarters remain fixed (Q1–Q4).
Future<void> openCategoryFilterSheetReports(
  BuildContext context, {
  List<String> quarters = const ["Q1", "Q2", "Q3", "Q4"],
  required String? selectedYear,
  required String? selectedQuarter,
  required void Function(String? year, String? quarter) onApply,
}) {
  String? tempYear = selectedYear;
  String? tempQuarter = selectedQuarter;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
             padding: EdgeInsets.only(
  bottom: MediaQuery.of(context).viewInsets.bottom +
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
                  // Drag handle
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter Category Data",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bodytextColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setSheetState(() {
                            tempYear = null;
                            tempQuarter = null;
                          });
                        },
                        child: const Text(
                          "Reset",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Year — modern calendar-style year picker, any year selectable
                  const Text(
                    "Membership Year",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bodytextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  YearPickerField(
                    value: tempYear,
                    hintText: "Select year",
                    onChanged: (val) {
                      setSheetState(() {
                        tempYear = val;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Quarter — fixed, always available
                  const Text(
                    "Quarter",
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
                      final isSelected = tempQuarter == q;
                      return _FilterChip(
                        label: q,
                        selected: isSelected,
                        onTap: () {
                          setSheetState(() {
                            tempQuarter = isSelected ? null : q;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 26),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        onApply(tempYear, tempQuarter);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Apply Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
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


class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
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
