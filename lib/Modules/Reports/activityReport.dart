import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Activityreport extends StatefulWidget {
  const Activityreport({super.key});

  @override
  State<Activityreport> createState() => _ActivityreportState();
}

class _ActivityreportState extends State<Activityreport> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ActivityReportCard(
            icon: LucideIcons.check,
            statusColor: AppColors.primary,
            title: "New manifest submitted",
            subtitle: "ABC Industries",
            timeAgo: "2 hours ago",
            status: "Active",
          ),

          ActivityReportCard(
            icon: LucideIcons.truck,
            statusColor: AppColors.inProgress,
            title: "New manifest submitted",
            subtitle: "ABC Industries",
            timeAgo: "1 day ago",
            status: "In progress",
          ),

          ActivityReportCard(
            icon: LucideIcons.alertCircle,
            statusColor: AppColors.error,
            title: "New manifest submitted",
            subtitle: "ABC Industries",
            timeAgo: "3 days ago",
            status: "Alert",
          ),

          ActivityReportCard(
            icon: LucideIcons.alertCircle,
            statusColor: AppColors.secondary,
            title: "New manifest submitted",
            subtitle: "ABC Industries",
            timeAgo: "8 days ago",
            status: "Pending",
          ),
        ],
      ),
    );
  }
}

class ActivityReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String timeAgo;
  final String status;
  final Color statusColor;

  const ActivityReportCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textfieldBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT ICON
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),

          const SizedBox(width: 12),

          // MIDDLE TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.bodytextColor.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),

          // RIGHT TIME + STATUS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeAgo,
                style: TextStyle(
                    color: AppColors.bodytextColor.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600
                  ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
