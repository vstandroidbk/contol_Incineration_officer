import 'package:contol_officer_app/Controller/profileController.dart';
import 'package:contol_officer_app/utils/appSession.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/widgets/loader.dart';
import 'package:contol_officer_app/widgets/profile_header.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController _profileController = Get.find<ProfileController>();
  bool _showAllPincodes = false;

  @override
  void initState() {
    super.initState();
    _profileController.fetchOfficerProfile(); 
  }

  void _showProfileImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Full-screen image
              Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 100,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Close button
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(title: ""),
      body: Obx(() {
        final profile = _profileController.officerProfile.value;

        return LoaderWrapper(
          isLoading: _profileController.isLoading.value,
          shimmerItems: 10,
          showCard: true,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 16,
                    right: 16,
                    bottom: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (profile?.profile != null &&
                              profile!.profile!.isNotEmpty) {
                            _showProfileImage(context, profile.profile!);
                          }
                        },
                        child: Profileheader(profileImageUrl: profile?.profile),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            profile?.fullName ?? "—",
                            style: TextStyle(
                              color: AppColors.bodytextColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            profile?.loginId ?? "—",
                            style: TextStyle(
                              color: AppColors.bodytextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.shieldCheck, size: 22),
                              const SizedBox(width: 10),
                              Text(
                                'Regional Officer',
                                style: TextStyle(
                                  color: AppColors.bodytextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.users,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${profile?.memberCount ?? 0} Customers Managed", // 👈 was hardcoded 127
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          _InfoSectionContainer(
                            title: "Contact Information",
                            child: Column(
                              children: [
                                _InfoRow(
                                  icon: Icons.email_outlined,
                                  label: "Email",
                                  value:
                                      profile?.email ?? "—", // 👈 was hardcoded
                                ),
                                Divider(color: AppColors.textfieldBorder),
                                _InfoRow(
                                  icon: Icons.phone_outlined,
                                  label: "Phone",
                                  value:
                                      profile?.mobileNumber ??
                                      "—", // 👈 was hardcoded
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          _InfoSectionContainer(
                            title: "Assigned District",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        LucideIcons.mapPin,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profile?.districtName ??
                                              "—", // 👈 was "North Maharashtra"
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.bodytextColor,
                                          ),
                                        ),
                                        Text(
                                          "${profile?.pinCodes.length ?? 0} Pincode", // 👈 was "5 Pincode"
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.bodytextColor
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Assigned Pincodes",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.bodytextColor.withOpacity(
                                      0.7,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Divider(color: AppColors.textfieldBorder),
                                const SizedBox(height: 4),

                                Builder(
                                  builder: (context) {
                                    final allPins = profile?.pinCodes ?? [];
                                    const int previewCount = 6;
                                    final bool hasMore =
                                        allPins.length > previewCount;
                                    final visiblePins = _showAllPincodes
                                        ? allPins
                                        : allPins.take(previewCount).toList();

                                    return AnimatedSize(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          ...visiblePins.map(
                                            (pin) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: AppColors.primary
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              child: Text(
                                                pin,
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),

                                          // 👇 "See more / Show less" flows in the same Wrap, same row if space allows
                                          if (hasMore)
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                setState(() {
                                                  _showAllPincodes =
                                                      !_showAllPincodes;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      _showAllPincodes
                                                          ? "Show less"
                                                          : "+${allPins.length - previewCount} more",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Icon(
                                                      _showAllPincodes
                                                          ? LucideIcons
                                                                .chevronUp
                                                          : LucideIcons
                                                                .chevronDown,
                                                      size: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          _InfoSectionContainer(
                            title: "Employment Details",
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.container4.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        LucideIcons.calendar,
                                        color: AppColors.container4,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Join Date",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.bodytextColor
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          profile?.joiningDate ??
                                              "Not available", // 👈 handles null gracefully
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.bodytextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // ElevatedButton.icon(
                                //   onPressed: () {},
                                //   icon: Icon(LucideIcons.download),
                                //   label: const Text("Officer ID Card"),
                                //   style: ElevatedButton.styleFrom(
                                //     foregroundColor: Colors.white,
                                //     backgroundColor: AppColors.primary,
                                //     padding: const EdgeInsets.symmetric(
                                //       vertical: 6,
                                //       horizontal: 12,
                                //     ),
                                //     minimumSize: const Size(0, 32),
                                //     tapTargetSize:
                                //         MaterialTapTargetSize.shrinkWrap,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      Get.toNamed(AppRoutes.editProfile),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.bodytextColor,
                                    side: const BorderSide(
                                      color: AppColors.textfieldBorder,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    minimumSize: const Size(0, 40),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text("Edit Profile"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    CustomDialog.show(
                                      title: "Logout",
                                      textColor: Colors.red,
                                      message:
                                          "Are you sure you want to logout?",
                                      confirmText: "Yes, Logout",
                                      cancelText: "Cancel",
                                      onConfirm: () {
                                        AppSession.logout();
                                        Get.offAllNamed(AppRoutes.login);
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    minimumSize: const Size(0, 40),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text("LogOut"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// Reusable container for info sections with title and box styling
class _InfoSectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoSectionContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.bodytextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.textfieldBorder, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.bodytextColor.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}

// Reusable row for icon, label and value in contact info
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.bodytextColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bodytextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
