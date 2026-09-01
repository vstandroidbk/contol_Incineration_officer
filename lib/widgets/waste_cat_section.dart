import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/widgets/open_cat_filter_member.dart';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class WasteCategorySection extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> categories;
  final List<String> years;
  final List<int> quarters;
  final int? totalCount;
  final bool isLoading;       // 👈 NEW
  final String? errorMessage; // 👈 NEW
  final void Function(String? year, String? quarter)? onFilterChanged;

  const WasteCategorySection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.categories,
    this.years = const [],
    this.quarters = const [],
    this.totalCount,
    this.isLoading = false,
    this.errorMessage,
    this.onFilterChanged,
  });

  @override
  State<WasteCategorySection> createState() => _WasteCategorySectionState();
}

class _WasteCategorySectionState extends State<WasteCategorySection> {
  String? selectedYear;
  String? selectedQuarter;

  void _openFilter() {
    openCategoryFilterSheetMember(
      context,
      years: widget.years,
      quarters: widget.quarters,
      selectedYear: selectedYear,
      selectedQuarter: selectedQuarter,
      onApply: (year, quarter) {
        setState(() {
          selectedYear = year;
          selectedQuarter = quarter;
        });
        widget.onFilterChanged?.call(year, quarter);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFilter = selectedYear != null || selectedQuarter != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header + filter button — ALWAYS visible ─────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.bodytextColor,
                        ),
                      ),
                      if (widget.totalCount != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${widget.totalCount}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lighttextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _openFilter,
              icon: const Icon(
                LucideIcons.slidersHorizontal,
                size: 15,
                color: Colors.white,
              ),
              label: const Text(
                "Apply Filter",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),

        // Active filter chip
        if (hasFilter) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      [
                        if (selectedYear != null) selectedYear,
                        if (selectedQuarter != null) selectedQuarter,
                      ].join(" • "),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedYear = null;
                          selectedQuarter = null;
                        });
                        widget.onFilterChanged?.call(null, null);
                      },
                      child: const Icon(
                        LucideIcons.x,
                        size: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 14),

        // ── Content area — loading / error / empty / list ────
        if (widget.isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Text(
                widget.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.error,
                ),
              ),
            ),
          )
        else if (widget.categories.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Text(
                "No waste category data available",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lighttextColor,
                ),
              ),
            ),
          )
        else
          ...widget.categories.map(
            (c) => _CategoryRow(
              title: c["title"],
              number: c["number"],
              authorized: c["authorized"],
              used: c["used"],
              unit: c["unit"],
              active: c["active"],
              memberName: c["memberName"],
            ),
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Category Row
// ══════════════════════════════════════════════════════════════
class _CategoryRow extends StatelessWidget {
  final String title;
  final String number;
  final int authorized;
  final int used;
  final String unit;
  final bool active;
  final String? memberName;

  const _CategoryRow({
    required this.title,
    required this.number,
    required this.authorized,
    required this.used,
    required this.unit,
    required this.active,
    this.memberName,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
        authorized == 0 ? 0 : (used / authorized).clamp(0, 1).toDouble();
    final bool isFull = used >= authorized;
    final Color barColor = isFull ? AppColors.error : AppColors.primary;
    final statusColor = active ? AppColors.success : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textfieldBorder.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.bodytextColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.container4.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.container4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                    if (memberName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        memberName!,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lighttextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(top: 3, left: 6),
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _ValueBlock(
                  label: "Authorized",
                  value: "$authorized $unit",
                  color: AppColors.bodytextColor,
                ),
              ),
              Expanded(
                child: _ValueBlock(
                  label: "Used",
                  value: "$used $unit",
                  color: barColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.tabBarColor,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${(progress * 100).toStringAsFixed(0)}% utilized",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.lighttextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ValueBlock({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.bodytextColor),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}