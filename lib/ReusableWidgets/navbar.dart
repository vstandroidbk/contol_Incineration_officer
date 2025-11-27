import 'package:contol_officer_app/Controller/navBar_controller.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavBarDesign extends StatelessWidget {
  BottomNavBarDesign({super.key});

  final controller = Get.find<BottomNavBarController>();

  final List<IconData> icons = [
    LucideIcons.home,
    LucideIcons.barChart,
    LucideIcons.alertTriangle,
    LucideIcons.clipboard,
    LucideIcons.user,
  ];

  final List<String> labels = [
    'Home',
    'Reports',
    'Concerns',
    'Field',
    'Profile',
  ];

  // final List<String> routes = [
  //   AppRoutes.homeview,
  //   AppRoutes.reports,
  //   AppRoutes.concern,
  //   AppRoutes.field,
  //   AppRoutes.profile,
  // ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        bottom: true,
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(icons.length, (index) {
                final isSelected = index == controller.currentIndex.value;

                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      controller.changeTab(index);
                     
                    },

                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icons[index],
                            size: 22,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.lighttextColor,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.lighttextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
