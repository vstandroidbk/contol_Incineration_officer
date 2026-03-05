import 'package:contol_officer_app/Controller/Nav/navbar_controller.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color bgColor;

  const QuickActionItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: bgColor, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        "label": "View Reports",
        "icon": LucideIcons.clipboard,
        "onTap": () {
          final nav = Get.find<BottomNavBarController>();
          nav.changeTab(1);
        },
        "BgColor": AppColors.container4,
      },
      {
        "label": "Raise Concern",
        "icon": LucideIcons.alertTriangle,
        "onTap": () {
          final nav = Get.find<BottomNavBarController>();
          nav.changeTab(2);
        },
        "BgColor": AppColors.primary,
      },
      {
        "label": "Field Report",
        "icon": LucideIcons.trendingUp,
        "onTap": () {
          final nav = Get.find<BottomNavBarController>();
          nav.changeTab(3);
        },
        "BgColor": AppColors.secondary,
      },
      {
        "label": "District View",
        "icon": LucideIcons.landmark,
        "onTap": () {
          final nav = Get.find<BottomNavBarController>();
          nav.changeTab(1);
        },
        "BgColor": AppColors.container5.withOpacity(0.8),
      },
    ];

    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: actions.map((item) {
        return QuickActionItem(
          bgColor: item['BgColor'],
          icon: item["icon"],
          label: item["label"],
          onTap: item["onTap"],
        );
      }).toList(),
    );
  }
}