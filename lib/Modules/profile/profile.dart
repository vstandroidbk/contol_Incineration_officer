import 'package:contol_officer_app/ReusableWidgets/appBar.dart';
import 'package:contol_officer_app/ReusableWidgets/loader.dart';
import 'package:contol_officer_app/ReusableWidgets/navbar.dart';
import 'package:contol_officer_app/ReusableWidgets/profileHeader.dart';
import 'package:contol_officer_app/Routes/app_routes.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/utils/dialogBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Sample assigned districts for tags
  final List<String> assignedDistricts = [
    "Nashik",
    "Pune",
    "Mumbai",
    "Nagpur",
    "Aurangabad",
  ];
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
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(title: ""),
      body: LoaderWrapper(
        isLoading: isLoading,
        shimmerItems: 10,
        showCard: true,
        child: SafeArea(
          child: Column(
            children: [
              // Fixed top profile header & basic info
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 16,
                  right: 16,
                  bottom: 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Profileheader()],
                ),
              ),

              // Expanded scrollable section after status container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Rajesh Kumar',
                          style: TextStyle(
                            color: AppColors.bodytextColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'RO-2025-MH-045',
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
                        const SizedBox(height: 16),
                        // Status containers grid
                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _StatusContainer(
                              count: 125,
                              label: 'Reports',
                              textColor: AppColors.Container4,
                            ),
                            _StatusContainer(
                              count: 67,
                              label: 'Concerns',
                              textColor: AppColors.primary,
                            ),
                            _StatusContainer(
                              count: 134,
                              label: 'Customers',
                              textColor: AppColors.secondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Contact Information Container
                        _InfoSectionContainer(
                          title: "Contact Information",
                          child: Column(
                            children: [
                              _InfoRow(
                                icon: Icons.email_outlined,
                                label: "Email",
                                value: "rajesh.kumar@controlincineration.com",
                              ),
                              Divider(color: AppColors.textfieldBorder),
                              _InfoRow(
                                icon: Icons.phone_outlined,
                                label: "Phone",
                                value: "+91 98765 43210",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Assigned Region Container
                        _InfoSectionContainer(
                          title: "Assigned Region",
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
                                        "North Maharashtra",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: AppColors.bodytextColor,
                                        ),
                                      ),

                                      Text(
                                        "5 Districts",
                                        style: TextStyle(
                                          fontSize: 14,
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
                                "Assigned Districts:",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.bodytextColor.withOpacity(
                                    0.6,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Divider(color: AppColors.textfieldBorder),
                              const SizedBox(height: 8),

                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: assignedDistricts
                                    .map(
                                      (district) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: Text(
                                          district,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Employment Details Container
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
                                      color: AppColors.Container4.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: Icon(
                                      LucideIcons.calendar,
                                      color: AppColors.Container4,
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
                                        "January 15, 2023",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: AppColors.bodytextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Handle Officer ID Card press
                                },
                                icon: Icon(LucideIcons.download),
                                label: const Text("Officer ID Card"),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 12,
                                  ),
                                  minimumSize: const Size(0, 32),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // BOTTOM BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.editProfile);
                                },
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
                                    message: "Are you sure you want to logout?",
                                    confirmText: "Yes, Logout",
                                    cancelText: "Cancel",
                                    onConfirm: () {
                                      print("User Logged Out");
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

                        const SizedBox(
                          height: 20,
                        ), // Extra bottom padding for scroll
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
            fontSize: 18,
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
                  fontSize: 14,
                  color: AppColors.bodytextColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
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

class _StatusContainer extends StatelessWidget {
  final int count;
  final String label;
  final Color textColor;

  const _StatusContainer({
    required this.count,
    required this.label,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.bodytextColor.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.bodytextColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
