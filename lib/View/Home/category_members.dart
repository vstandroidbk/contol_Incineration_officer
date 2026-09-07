import 'package:contol_officer_app/Controller/homecontroller.dart';
import 'package:contol_officer_app/View/Customers/customer_details.dart'; // 👈 add
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class CategoryMembers extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  final String categoryNumber;

  const CategoryMembers({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryNumber,
  });

  @override
  State<CategoryMembers> createState() => _CategoryMembersState();
}

class _CategoryMembersState extends State<CategoryMembers> {
  final MemberController memberController = Get.find<MemberController>();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => memberController.fetchMembersByCategory(widget.categoryId),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(
        title: widget.categoryTitle,
        subtitle: "Category ${widget.categoryNumber}",
        showBack: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSearchBar(
                controller: _controller,
                hintText: "Search by member id or industry name",
                icon: LucideIcons.search,
                autofocus: false,
                onChanged: (val) => memberController.searchCategoryMembers(val),
              ),

              const SizedBox(height: 14),

              Obx(() {
                if (memberController.isCategoryMembersLoading.value) {
                  return const SizedBox.shrink();
                }
                return Row(
                  children: [
                    _CountChip(
                      label:
                          "${memberController.categoryMembers.length} members",
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    _CountChip(
                      label:
                          "${memberController.categoryPincodeCount.value} pincodes",
                      color: AppColors.container4,
                    ),
                  ],
                );
              }),

              const SizedBox(height: 14),

              Expanded(
                child: Obx(() {
                  if (memberController.isCategoryMembersLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (memberController
                      .categoryMembersErrorMessage
                      .value
                      .isNotEmpty) {
                    return Center(
                      child: Text(
                        memberController.categoryMembersErrorMessage.value,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  if (memberController.categoryMembers.isEmpty) {
                    return Center(
                      child: Text(
                        "No members found",
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
                    itemCount: memberController.categoryMembers.length,
                    itemBuilder: (context, index) {
                      final m = memberController.categoryMembers[index];
                      return _MemberTile(
                        member: m,
                        onTap: () {
                          // 👇 add — navigate to CustomerDetails with real data
                          Get.to(
                            () => CustomerDetails(
                              memberId: m
                                  .membershipId, // used by controller to fetch category/years
                              customerId: m.membershipUserId,
                              companyName: m.industryName,
                              isActive: m.isActive,
                              memberTill: m.validTill,
                              address: m.plantAddress,
                              profileImageUrl: m.profile,
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

class _CountChip extends StatelessWidget {
  final String label;
  final Color color;

  const _CountChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Member tile — tappable, opens CustomerDetails
// ══════════════════════════════════════════════════════════════
class _MemberTile extends StatelessWidget {
  final dynamic member; // CategoryMemberModel
  final VoidCallback onTap; // 👈 add

  const _MemberTile({required this.member, required this.onTap}); // 👈 add

  String get _initials {
    final String name = (member.industryName as String).trim();
    if (name.isEmpty) return "?";
    final words = name.split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return (words[0][0] + words[1][0]).toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String? profileUrl = member.profile as String?;

    return Container(
     margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textfieldBorder.withOpacity(0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.bodytextColor.withOpacity(0.08),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // 👇 add — Material + InkWell for tap + ripple, clipped to rounded corners
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.gradient1, AppColors.gradient2],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradient1.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        image: profileUrl != null
                            ? DecorationImage(
                                image: NetworkImage(profileUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: profileUrl == null
                          ? Text(
                              _initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.industryName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.bodytextColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Member Id - ${member.membershipUserId}",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.bodytextColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: (member.isActive ? Colors.green : Colors.grey)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        member.isActive ? "Active" : "Inactive",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: member.isActive ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      LucideIcons.chevronRight, // 👈 add — affordance hint
                      size: 16,
                      color: AppColors.lighttextColor.withOpacity(0.5),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  color: AppColors.textfieldBorder.withOpacity(0.6),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      LucideIcons.mapPin,
                      size: 12,
                      color: AppColors.bodytextColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      member.pinCode,
                       style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.bodytextColor.withOpacity(0.7),
                              ),
                    ),
                  ],
                ),
                const SizedBox(height:8),
                // Text(
                //   member.plantAddress,
                //   maxLines: 4,
                //   overflow: TextOverflow.visible,
                //   style: TextStyle(
                //     fontSize: 12,
                //     fontWeight: FontWeight.w600,
                //    color: AppColors.bodytextColor.withOpacity(0.7),
                //   ),
                // ),
                // const SizedBox(height: 6),
                Text(
                  "Valid: ${member.validFrom} – ${member.validTill}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lighttextColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
