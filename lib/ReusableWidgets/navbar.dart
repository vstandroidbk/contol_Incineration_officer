import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavBarDesign extends StatefulWidget {
  const BottomNavBarDesign({super.key});

  @override
  State<BottomNavBarDesign> createState() => _BottomNavBarDesignState();
}

class _BottomNavBarDesignState extends State<BottomNavBarDesign> {
  int selectedIndex = 0;

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

  final List<String> routes = [
    AppRoutes.homeview,
    AppRoutes.reports,
    AppRoutes.concern,
    AppRoutes.field,
    AppRoutes.profile,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != null && routes.contains(currentRoute)) {
      setState(() {
        selectedIndex = routes.indexOf(currentRoute);
      });
    }
  }

  void onItemTapped(int index, BuildContext context) {
    if (index == selectedIndex) return;
    setState(() {
      selectedIndex = index;
    });
    Navigator.pushNamedAndRemoveUntil(context, routes[index], (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            final isSelected = index == selectedIndex;
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onItemTapped(index, context),
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
    );
  }
}
