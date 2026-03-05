import 'package:contol_officer_app/View/Home/homeHeader.dart';
import 'package:contol_officer_app/View/Home/quick_action.dart';
import 'package:contol_officer_app/View/Home/recent_activities.dart';
import 'package:contol_officer_app/View/Home/stats_card.dart';
import 'package:contol_officer_app/View/Home/upcoming_tasks.dart';
import 'package:contol_officer_app/widgets/loader.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  bool isLoading = true;
  int notificationCount = 10;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarH = MediaQuery.of(context).padding.top;

    // Collapsed height:
    //   statusBar + topPad(8) + row height(40) + compact name(20) + top(4) + bottomPad(6)
    final double collapsedH = statusBarH + 8 + 40 + 4 + 20 ;

    // Expanded height = collapsed + welcome block:
    //   topSpacing(16) + "Welcome Back"(22) + name(28) + gap(8) + region(22) + extraBottomPad(18)
    final double expandedH = collapsedH + 16 + 22 + 28 + 8 + 22 ;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoaderWrapper(
        isLoading: isLoading,
        shimmerItems: 10,
        showCard: true,
        child: CustomScrollView(
          slivers: [
            // ── Collapsible Header ──────────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: HomeHeaderDelegate(
                collapsedHeight: collapsedH,
                expandedHeight: expandedH,
                statusBarH: statusBarH,
                notificationCount: notificationCount,
                onNotificationTap: () =>
                    Get.toNamed(AppRoutes.notifications),
              ),
            ),

            // ── Body Content ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const StatsGrid(),
                    const SizedBox(height: 16),

                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.bodytextColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const QuickActionsGrid(),

                    const SizedBox(height: 16),
                    const Text(
                      "Upcoming Tasks",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const UpcomingTasksList(),

                    const SizedBox(height: 12),

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

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}