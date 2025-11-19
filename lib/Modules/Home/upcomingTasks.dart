import 'package:flutter/material.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UpcomingTaskItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String priority; // High, Medium, Low

  const UpcomingTaskItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.priority,
  });

  Color _priorityColor() {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return AppColors.inProgress;
      case "Low":
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  IconData _priorityIcon() {
    switch (priority) {
      case "High":
        return LucideIcons.arrowUpFromLine;
      case "Medium":
        return LucideIcons.arrowUpFromLine;
      case "Low":
        return LucideIcons.arrowDownFromLine;
      default:
        return LucideIcons.minus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textfieldBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.bodytextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: 18,
                      color: AppColors.lighttextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bodytextColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Right Side: Time + Priority Icon
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(_priorityIcon(), size: 22, color: _priorityColor()),
              const SizedBox(height: 4),

              Text(
                priority,
                style: TextStyle(
                  fontSize: 14,
                  color: _priorityColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpcomingTasksList extends StatelessWidget {
  const UpcomingTasksList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tasks = [
      {
        "title": "Review District 3 quarterly report",
        "subtitle": "Today",
        "time": "Today",
        "priority": "High",
      },
      {
        "title": "ME-2025-001233",
        "subtitle": "Tomorrow",
        "time": "Tomorrow",
        "priority": "Medium",
      },
      {
        "title": "MF-2025-001232",
        "subtitle": "In 3 days",
        "time": "In 3 days",
        "priority": "Low",
      },
    ];

    return Column(
      children: tasks.map((task) {
        return UpcomingTaskItem(
          title: task["title"]!,
          subtitle: task["subtitle"]!,
          time: task["time"]!,
          priority: task["priority"]!,
        );
      }).toList(),
    );
  }
}
