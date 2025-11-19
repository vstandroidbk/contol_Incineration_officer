import 'package:flutter/material.dart';
import 'package:contol_officer_app/utils/colors.dart';

class RecentActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Color dotColor;

  const RecentActivityItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status dot
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),

          const SizedBox(width: 12),

          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.bodytextColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.bodytextColor.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Time
          Text(
            time,
            style:  TextStyle(
              fontSize: 12,
              color: AppColors.bodytextColor.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentActivitiesList extends StatelessWidget {
  const RecentActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {
        "title": "New manifest submitted",
        "subtitle": "ABC Industries",
        "time": "2 hours ago",
        "color": AppColors.success
      },
      {
        "title": "Concern raised",
        "subtitle": "xyz Corp",
        "time": "5 hours ago",
        "color": AppColors.secondary
      },
      {
        "title": "Capacity exceeded",
        "subtitle": "Tech Solutions Ltd",
        "time": "1 day ago",
        "color": Colors.red,
      },
      {
        "title": "Report submitted",
        "subtitle": "Green Energy Co",
        "time": "2 days ago",
        "color": AppColors.Container4
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textfieldBorder, width: 1),
      ),
      child: Column(
        children: activities.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Column(
            children: [
              RecentActivityItem(
                title: item["title"],
                subtitle: item["subtitle"],
                time: item["time"],
                dotColor: item["color"],
              ),
              // Divider between items (except last)
              if (index != activities.length - 1)
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.textfieldBorder.withOpacity(0.4),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
