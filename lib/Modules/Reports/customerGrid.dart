import 'dart:ui';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Customergrid extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String count;
  final String label;
  final VoidCallback? onTap;
  final String subLabel;
  final Color subLabelColor;

  const Customergrid({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.count,
    required this.label,
    this.onTap,
    required this.subLabel,
    required this.subLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: AppColors.textfieldBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.bodytextColor.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subLabel,
              style: TextStyle(fontSize: 12, color: subLabelColor,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerGridItem extends StatelessWidget {
  const CustomerGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stats = [
      {
        "icon": LucideIcons.users,
        "iconBg": AppColors.primary,
        "count": "127",
        "label": "Active Customers",
        "onTap": () {},
        "subLabel": "42 Active",
        "subLabelColor": AppColors.success,
      },
      {
        "icon": LucideIcons.fileBarChart,
        "iconBg": AppColors.secondary,
        "count": "18",
        "label": "Pending ",
        "onTap": () {},
        "subLabel": "This Quarter",
        "subLabelColor": AppColors.bodytextColor.withOpacity(0.6),
      },
      {
        "icon": LucideIcons.alertTriangle,
        "iconBg": AppColors.Container3,
        "count": "18",
        "label": "Open Concerns",
        "onTap": () {},
        "subLabel": "Overll Usage",
        "subLabelColor": AppColors.bodytextColor.withOpacity(0.6),
      },
      {
        "icon": LucideIcons.mapPin,
        "iconBg": AppColors.Container4,
        "count": "7",
        "label": "Districts",
        "onTap": () {},
        "subLabel": "5 Pickup Alerts",
        "subLabelColor": AppColors.error,
      },
    ];

    return GridView.count(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.3,

      children: stats.map((item) {
        return Customergrid(
          icon: item['icon'],
          iconBgColor: item['iconBg'],
          count: item['count'],
          label: item['label'],
          onTap: item['onTap'],
          subLabel: item['subLabel'],
          subLabelColor: item['subLabelColor'],
        );
      }).toList(),
    );
  }
}
