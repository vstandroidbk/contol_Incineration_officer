import 'package:contol_officer_app/Controller/Nav/navbar_controller.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double statusBarH;
  final int notificationCount;
  final VoidCallback onNotificationTap;

  final String officerName;
  final String districtName;
  final String? profileImageUrl;

  const HomeHeaderDelegate({
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.statusBarH,
    required this.notificationCount,
    required this.onNotificationTap,
    required this.officerName,
    required this.districtName,
    this.profileImageUrl,
  });

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  bool shouldRebuild(covariant HomeHeaderDelegate old) =>
      old.notificationCount != notificationCount ||
      old.expandedHeight != expandedHeight ||
      old.collapsedHeight != collapsedHeight ||
      old.officerName != officerName ||
      old.districtName != districtName ||
      old.profileImageUrl != profileImageUrl;

  // ✅ FIXED — was Get.toNamed(AppRoutes.profile), which pushed a
  // standalone Profile route outside MainScreen's IndexedStack, losing
  // the bottom nav bar. Profile is a TAB (index 3), not a separate
  // route — switch tabs via BottomNavBarController instead.
  void _goToProfileTab() {
    Get.find<BottomNavBarController>().changeTab(3);
  }

  void _handleLogout(BuildContext context) {
    CustomDialog.show(
      title: "Logout",
      textColor: Colors.red,
      message: "Are you sure you want to logout?",
      confirmText: "Yes, Logout",
      cancelText: "Cancel",
      onConfirm: () {
        AppSession.logout();
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double totalShrink = expandedHeight - collapsedHeight;
    final double t = (shrinkOffset / totalShrink).clamp(0.0, 1.0);

    final double contentOpacity = (1.0 - t * 1.8).clamp(0.0, 1.0);
    final double nameOpacity = (t * 2.5 - 1.2).clamp(0.0, 1.0);
    final double topSpacing = 16.0 * (1.0 - t);
    final double bottomPad = (18.0 * (1.0 - t)) + 6.0;

    final double currentHeight = (expandedHeight - shrinkOffset).clamp(
      collapsedHeight,
      expandedHeight,
    );

    final String displayName = officerName.isNotEmpty
        ? "Officer $officerName"
        : "Officer";

    return SizedBox(
      height: currentHeight,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradient1, AppColors.gradient2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: statusBarH + 2,
            bottom: bottomPad,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Contol",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      letterSpacing: 1.5,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: onNotificationTap,
                        borderRadius: BorderRadius.circular(20),
                        child: Badge(
                          backgroundColor: Colors.white,
                          alignment: Alignment.topRight,
                          isLabelVisible: notificationCount > 0,
                          label: Text(
                            notificationCount > 9
                                ? '9+'
                                : notificationCount.toString(),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.bell,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap:
                            _goToProfileTab, // ✅ FIXED — was Get.toNamed(AppRoutes.profile)
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          backgroundImage:
                              (profileImageUrl != null &&
                                  profileImageUrl!.isNotEmpty)
                              ? NetworkImage(profileImageUrl!)
                              : null,
                          child:
                              (profileImageUrl == null ||
                                  profileImageUrl!.isEmpty)
                              ? const Icon(
                                  LucideIcons.user,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => _handleLogout(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.logOut,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (nameOpacity > 0)
                Opacity(
                  opacity: nameOpacity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ClipRect(
                child: Align(
                  alignment: Alignment.topLeft,
                  heightFactor: (1.0 - t).clamp(0.0, 1.0),
                  child: Opacity(
                    opacity: contentOpacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: topSpacing),
                        const Text(
                          "Welcome Back, ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "District: ${districtName.isNotEmpty ? districtName : '—'}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
