import 'package:contol_officer_app/Controller/customerController.dart';
import 'package:contol_officer_app/Controller/profileController.dart';
import 'package:contol_officer_app/View/Customers/all_customer.dart';
import 'package:contol_officer_app/View/Customers/customer_card.dart';
import 'package:contol_officer_app/View/Customers/customer_details.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/widgets/loader.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final AllCustomersController _allCustomersController = Get.put(
    AllCustomersController(),
  );

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _profileController.fetchOfficerProfile();
      _allCustomersController.fetchAllMembers();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const CustomAppBar(
        title: "Customers",
        subtitle: "Members under your district",
      ),
      body: LoaderWrapper(
        isLoading: isLoading,
        shimmerItems: 10,
        showCard: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final profile = _profileController.officerProfile.value;
                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _StatusContainer(
                        count: "${profile?.memberCount ?? 0}",
                        label: 'Assigned Customers',
                        textColor: AppColors.primary,
                      ),
                      _StatusContainer(
                        count: "${profile?.pinCodes.length ?? 0}",
                        label: 'Active Pincode',
                        textColor: AppColors.secondary,
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recently Interacted",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const AllCustomers());
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        children: const [
                          Text(
                            "View All",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            LucideIcons.chevronRight,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Obx(() {
                    if (_allCustomersController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final recent = _allCustomersController.recentMembers;

                    if (recent.isEmpty) {
                      return Center(
                        child: Text(
                          "No recent customers",
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lighttextColor,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: recent.length,
                      itemBuilder: (context, index) {
                        final c = recent[index];
                        return CustomerCard(
                          customerId: c.membershipUserId, // 👈 display id
                          companyName: c.industryName,
                          isActive: c.isActive,
                          memberTill: c.validTill ?? "-",
                          pincode: c.pinCode,
                          profileImageUrl: c.profile,
                          onViewDetails: () {
                            Get.to(
                              () => CustomerDetails(
                                customerId: c.membershipUserId,
                                memberId: c.membershipId,
                                companyName: c.industryName,
                                isActive: c.isActive,
                                memberTill: c.validTill ?? "-",
                                address: c.plantAddress ?? "-", // 👈 changed
                                profileImageUrl: c.profile,
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusContainer extends StatelessWidget {
  final String count;
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
            color: AppColors.bodytextColor.withOpacity(0.15),
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
                count,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.bodytextColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
