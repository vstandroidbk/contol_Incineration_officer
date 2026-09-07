import 'package:contol_officer_app/Controller/homecontroller.dart';
import 'package:contol_officer_app/View/Customers/customer_card.dart';
import 'package:contol_officer_app/View/Customers/customer_details.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class SearchByPincode extends StatefulWidget {
  const SearchByPincode({super.key});

  @override
  State<SearchByPincode> createState() => _SearchByPincodeState();
}

class _SearchByPincodeState extends State<SearchByPincode> {
  final TextEditingController _controller = TextEditingController();
  final MemberController memberController = Get.put(MemberController());

  @override
  void initState() {
    super.initState();
    Future.microtask(() => memberController.fetchAllMembers());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";

    // 👇 Try ISO parse first (old API format: 2036-03-30T18:30:00.000Z)
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
    } catch (_) {
      // 👇 Not ISO — likely already human-readable (new API: "March 31, 2036")
      return dateStr; // as-is return kar do, kyunki already formatted hai
    }
  }

  void _onSearchChanged(String val) {
    final trimmed = val.trim();
    if (trimmed.length >= 2) {
      // 👇 2+ digits typed → filter starts
      memberController.filterByPincode(trimmed);
    } else {
      // 👇 0 or 1 digit → show full list
      memberController.filterByPincode('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const CustomAppBar(
        title: "Search by Pincode",
        subtitle: "Find customers in a specific district",
        showBack: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Dedicated search bar for this screen ─────────
              AppSearchBar(
                controller: _controller,
                hintText: "Enter pincode",
                icon: LucideIcons.search,
                keyboardType: TextInputType.number,
                autofocus: true,
                onSubmitted: (val) => _onSearchChanged(val),
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 18),

              Obx(() {
                if (memberController.isLoading.value) {
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
                        "${memberController.members.length} customers found",
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

              // ── Results ────────────────────────────────────────
              Expanded(
                child: Obx(() {
                  if (memberController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (memberController.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        memberController.errorMessage.value,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  if (memberController.members.isEmpty) {
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
                    itemCount: memberController.members.length,
                    itemBuilder: (context, index) {
                      final c = memberController.members[index];
                      return CustomerCard(
                        customerId: c.membershipUserId,
                        companyName: c.industryName,
                        isActive: c.isActive,
                        memberTill: _formatDate(c.validTill),
                        pincode: c.pinCode,
                        profileImageUrl: c
                            .profile, // 👈 add this (param name matches CustomerCard)
                        onViewDetails: () {
                          Get.to(
                            () => CustomerDetails(
                              customerId: c.membershipUserId,
                              memberId: c.membershipId,
                              companyName: c.industryName,
                              isActive: c.isActive,
                              memberTill: _formatDate(c.validTill),
                              address:
                                  c.plantAddress ??
                                  "-", // ✅ real fallback instead of hardcoded
                              profileImageUrl: c
                                  .profile, // bonus: avatar bhi missing tha yahan
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
