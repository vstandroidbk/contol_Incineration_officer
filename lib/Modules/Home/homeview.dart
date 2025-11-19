import 'package:contol_officer_app/Modules/Home/quickAction.dart';
import 'package:contol_officer_app/Modules/Home/recentActivities.dart';
import 'package:contol_officer_app/Modules/Home/statsCard.dart';
import 'package:contol_officer_app/Modules/Home/upcomingTasks.dart';
import 'package:contol_officer_app/ReusableWidgets/loader.dart';
import 'package:contol_officer_app/ReusableWidgets/navbar.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate network/data load
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoaderWrapper(
        isLoading: isLoading,
        shimmerItems: 10,
        showCard: true,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gradient1, AppColors.gradient2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 60,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Top Row: Title | Notification & Avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Contol",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 2.5,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.notifications,
                              );
                            },
                            child: Icon(
                              LucideIcons.bell,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 15),
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(
                              "assets/images/profile.jpg",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Welcome Text
                  Text(
                    "Welcome Back, ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Officer Rajesh Kumar",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🔹 Region Text
                  Text(
                    "Region: North Maharashtra",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            //after top container
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Grid
                    const StatsGrid(),

                    const SizedBox(height: 20),

                    //quick action
                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    QuickActionsGrid(
                      actions: [
                        {
                          "label": "View Reports",
                          "icon": LucideIcons.clipboard,
                          "onTap": () {
                            Navigator.pushNamed(context, AppRoutes.reports);
                          },
                          "BgColor": AppColors.Container4,
                        },
                        {
                          "label": "Raise Concern",
                          "icon": LucideIcons.alertTriangle,
                          "onTap": () {
                            Navigator.pushNamed(context, AppRoutes.concern);
                          },
                          "BgColor": AppColors.primary,
                        },
                        {
                          "label": "Field Report",
                          "icon": LucideIcons.trendingUp,
                          "onTap": () {
                            Navigator.pushNamed(context, AppRoutes.field);
                          },
                          "BgColor": AppColors.secondary,
                        },
                        {
                          "label": "District View",
                          "icon": LucideIcons.landmark,
                          "onTap": () {
                            Navigator.pushNamed(context, AppRoutes.reports);
                          },
                          "BgColor": AppColors.Container5.withOpacity(0.8),
                        },
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Upcoming Tasks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    const UpcomingTasksList(),
                    const SizedBox(height: 10),

                    const Text(
                      "Recent Activities",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.bodytextColor,
                      ),
                    ),

                    const SizedBox(height: 12),
                    const RecentActivitiesList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarDesign(),
    );
  }
}
