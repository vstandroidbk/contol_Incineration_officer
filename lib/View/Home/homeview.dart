import 'package:contol_officer_app/Controller/notificationController.dart'; // 👈 add
import 'package:contol_officer_app/Controller/profileController.dart';
import 'package:contol_officer_app/View/Customers/all_customer.dart';
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
  final ProfileController _profileController = Get.find<ProfileController>();

  // 👈 add — resolve controller once, reuse the same instance app-wide
  final OfficerNotificationController _notificationController =
      Get.isRegistered<OfficerNotificationController>()
      ? Get.find<OfficerNotificationController>()
      : Get.put(OfficerNotificationController());

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _profileController.fetchOfficerProfile();
      _notificationController
          .fetchOfficerNotifications(); // 👈 add — keep badge fresh on entry
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  // 👇 add — pull-to-refresh handler
  Future<void> _onRefresh() async {
    await Future.wait([
      _profileController.fetchOfficerProfile(),
      _notificationController.fetchOfficerNotifications(),
    ]);
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
              // Obx already tracks officerProfile; accessing unreadCount here
              // registers it too, so this rebuilds on either change.
              final profile = _profileController.officerProfile.value;
              final int notificationCount =
                  _notificationController.unreadCount; // 👈 real count

              // 👇 add — RefreshIndicator wraps the scrollable directly
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.bodytextColor,
                child: CustomScrollView(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // 👈 add — ensures refresh works even when content < viewport
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
                                activePincodeCount:
                                    profile?.pinCodes.length ?? 0,
                                onCustomersTap: () {
                                  Get.to(() => const AllCustomers());
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
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
