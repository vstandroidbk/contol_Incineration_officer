import 'package:contol_officer_app/Controller/Nav/navbar_controller.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color bgColor;
  final Color iconColor;

  const QuickActionItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    required this.bgColor,
    required this.iconColor,
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
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color:iconColor, size: 24),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                 
                  letterSpacing: 0.3,
                ),
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
        "label": "View Customers",
        "icon": LucideIcons.users,
        "onTap": () {
          final nav = Get.find<BottomNavBarController>();
          nav.changeTab(1);
        },
        "BgColor": Colors.white,
        "iconColor":AppColors.gradient2
      },
        {
        "label": "View Reports",
        "icon": LucideIcons.clipboardList,
        "onTap": () {
          final nav = Get.find<BottomNavBarController>();
          nav.changeTab(2);
        },
        "BgColor": Colors.white,
        "iconColor":AppColors.primary,
      },
    ];

    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.0,
      children: actions.map((item) {
        return QuickActionItem(
          bgColor: item['BgColor'],
          icon: item["icon"],
          label: item["label"],
          onTap: item["onTap"],
          iconColor: item["iconColor"],
        );
      }).toList(),
    );
  }
}
