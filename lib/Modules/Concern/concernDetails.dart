import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../ReusableWidgets/appBar.dart';
import '../../utils/colors.dart';
import 'updateStatus.dart';

class ConcernDetailsScreen extends StatelessWidget {
  final String industryName;
  final String concern;
  final String detail;
  final String priority;
  final Color priorityColor;
  final String progress;
  final Color progressColor;
  final String goesTo;
  final String pickupDate;

  const ConcernDetailsScreen({
    super.key,
    required this.industryName,
    required this.concern,
    required this.detail,
    required this.priority,
    required this.priorityColor,
    required this.progress,
    required this.progressColor,
    required this.goesTo,
    required this.pickupDate,
  });

  bool isResolved(String value) {
    return value.toLowerCase() == "resolved";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        backgroundColor: AppColors.primary,
        title: "Concerns Details",
        subtitle: '',
        showBack: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(
              title: "Concern Type",
              value: concern,
              icon: LucideIcons.alertCircle,
            ),

            const SizedBox(height: 12),

            _detailRow(
              title: "Customer",
              value: industryName,
              icon: LucideIcons.user,
            ),

            const SizedBox(height: 12),

            _detailRow(
              title: "Description",
              value: detail,
              icon: LucideIcons.scrollText,
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textfieldBorder),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                priority,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bodytextColor,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _datePriorityRow(),

            const SizedBox(height: 12),

            _statusSection(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _updateButton(context),
        ),
      ),
    );
  }

  Widget _detailRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textfieldBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.lighttextColor),
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bodytextColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.bodytextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _priorityTag(String priority, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            priority,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _datePriorityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.calendar, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.bodytextColor.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              pickupDate,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),

        // Date
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.trendingUp,
                  size: 18,
                  color: AppColors.lighttextColor,
                ),
                const SizedBox(width: 6),
                Text(
                  "Priority",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.bodytextColor.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _priorityTag(priority, priorityColor),
          ],
        ),
      ],
    );
  }

  Widget _statusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Status",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.bodytextColor.withOpacity(0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: progressColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: progressColor),
              ),
              child: Text(
                progress,
                style: TextStyle(
                  color: progressColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(LucideIcons.moveRight, size: 18, color: Colors.grey),
            const SizedBox(width: 10),
            Text(
              goesTo,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.bodytextColor.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _updateButton(BuildContext context) {
    return isResolved(progress)
        ? const SizedBox.shrink()
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (_) => const UpdatestatusConcern(),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                minimumSize: const Size(0, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Update Status",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
  }
}
