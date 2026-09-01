import 'package:contol_officer_app/Controller/customerController.dart';
import 'package:contol_officer_app/View/Customers/customer_card.dart';
import 'package:contol_officer_app/View/Customers/customer_details.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class AllCustomers extends StatefulWidget {
  const AllCustomers({super.key});

  @override
  State<AllCustomers> createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  final TextEditingController _searchController = TextEditingController();
  final AllCustomersController allCustomersController = Get.put(
    AllCustomersController(),
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() => allCustomersController.fetchAllMembers());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const CustomAppBar(
        title: "All Customers",
        subtitle: "Full list under your district",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSearchBar(
                controller: _searchController,
                hintText: "Search by Member Id, Company name",
                icon: LucideIcons.search,
                onChanged: (val) => allCustomersController.search(val),
              ),
              const SizedBox(height: 16),

              Obx(() {
                if (allCustomersController.isLoading.value) {
                  return const SizedBox.shrink();
                }
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${allCustomersController.members.length} customers",
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 14),

              Expanded(
                child: Obx(() {
                  if (allCustomersController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (allCustomersController.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        allCustomersController.errorMessage.value,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  if (allCustomersController.members.isEmpty) {
                    return Center(
                      child: Text(
                        "No customers found",
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lighttextColor,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: allCustomersController.members.length,
                    itemBuilder: (context, index) {
                      final c = allCustomersController.members[index];
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
    );
  }
}
