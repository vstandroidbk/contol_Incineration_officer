import 'package:contol_officer_app/Controller/profileController.dart'; // 👈 add
import 'package:contol_officer_app/View/Home/homeHeader.dart';
import 'package:contol_officer_app/View/Home/quick_action.dart';
import 'package:contol_officer_app/View/Home/search_section.dart';
import 'package:contol_officer_app/View/Home/stats_card.dart';
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
  final ProfileController _profileController =
      Get.find<ProfileController>(); // 👈 add

  bool isLoading = true;
  int notificationCount = 10;

  @override
void initState() {
  super.initState();

  Future.microtask(() => _profileController.fetchOfficerProfile());

  Future.delayed(const Duration(milliseconds: 400), () {
    if (mounted) setState(() => isLoading = false);
  });
}


  @override
  Widget build(BuildContext context) {
    final double statusBarH = MediaQuery.of(context).padding.top;

    final double collapsedH = statusBarH + 8 + 40 + 4 + 20;
    final double expandedH = collapsedH + 16 + 22 + 28 + 8 + 12;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoaderWrapper(
        isLoading: isLoading,
        shimmerItems: 10,
        showCard: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double viewportH = constraints.maxHeight;
            final double minBodyHeight = viewportH - collapsedH;

            return Obx(() {
              // 👈 wrap in Obx so header rebuilds reactively
              final profile = _profileController.officerProfile.value;

              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: HomeHeaderDelegate(
                      collapsedHeight: collapsedH,
                      expandedHeight: expandedH,
                      statusBarH: statusBarH,
                      notificationCount: notificationCount,
                      onNotificationTap: () =>
                          Get.toNamed(AppRoutes.notifications),
                      officerName: profile?.fullName ?? "",
                      districtName: profile?.districtName ?? "",
                      profileImageUrl: profile?.profile,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: minBodyHeight),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Overview",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.bodytextColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            StatsGrid(
                              totalCustomers: profile?.memberCount ?? 0,
                              activePincodeCount: profile?.pinCodes.length ?? 0,
                              onCustomersTap: () {
                                // agar customers list screen hai to yahan navigate kro
                              },
                              onPincodeTap: () {
                                // agar pincode list screen hai to yahan navigate kro
                              },
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              "Search",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.bodytextColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const SearchSection(),

                            const SizedBox(height: 20),

                            const Text(
                              "Quick Actions",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.bodytextColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const QuickActionsGrid(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
  }
}
