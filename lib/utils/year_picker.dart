import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class YearPickerField extends StatelessWidget {
  final String? value;
  final String hintText;
  final ValueChanged<String?> onChanged;

  const YearPickerField({
    required this.value,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final picked = await _showYearPickerSheet(context, currentValue: value);
        if (picked != null) onChanged(picked);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textfieldBorder, width: 1.2),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: value == null
                  ? AppColors.textfieldBorder
                  : AppColors.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value ?? hintText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: value == null
                      ? Colors.grey.shade500
                      : AppColors.bodytextColor,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AppColors.textfieldBorder,
            ),
          ],
        ),
      ),
    );
  }
}

/// Opens a modern grid-based year picker (decade view with prev/next navigation).
/// Returns the selected year formatted as "YYYY-YY".
Future<String?> _showYearPickerSheet(
  BuildContext context, {
  String? currentValue,
}) {
  final int currentYear = DateTime.now().year;
  final int initialYear = currentValue != null
      ? int.tryParse(currentValue.split('-').first) ?? currentYear
      : currentYear;

  // Start the decade window so the initial year sits inside it.
  int decadeStart = initialYear - (initialYear % 12);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final years = List.generate(12, (i) => decadeStart + i);

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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

                // Header with decade navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${years.first} – ${years.last}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                    Row(
                      children: [
                        _NavIconButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: () => setState(() => decadeStart -= 12),
                        ),
                        const SizedBox(width: 6),
                        _NavIconButton(
                          icon: Icons.chevron_right_rounded,
                          onTap: () => setState(() => decadeStart += 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Year grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: years.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  itemBuilder: (context, i) {
                    final year = years[i];
                    final isSelected =
                        year == initialYear && currentValue != null;
                    final isCurrent = year == currentYear;

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        final end = (year + 1).toString().substring(2);
                        Navigator.pop(context, "$year-$end");
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isCurrent
                                      ? AppColors.primary.withOpacity(0.5)
                                      : AppColors.textfieldBorder),
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          "$year",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : AppColors.bodytextColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textfieldBorder, width: 1.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppColors.bodytextColor),
      ),
    );
  }
}
