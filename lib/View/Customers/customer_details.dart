import 'package:contol_officer_app/Controller/customerController.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/widgets/waste_cat_section.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class CustomerDetails extends StatefulWidget {
  final String? customerId;
  final String? memberId;
  final String? companyName;
  final bool? isActive;
  final String? memberTill;
  final String? address;
  final String? profileImageUrl;

  const CustomerDetails({
    super.key,
    this.customerId,
    this.memberId,
    this.companyName,
    this.isActive,
    this.memberTill,
    this.address,
    this.profileImageUrl,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  late final AllCustomersController controller;

  late String customerId;
  String? memberId;
  late String companyName;
  late bool isActive;
  late String memberTill;
  late String address;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>?;

    memberId = widget.memberId ?? args?['memberId']; // 👈 fixed key
    customerId = widget.customerId ?? args?['customerId'] ?? ''; // 👈 fixed key
    companyName =
        widget.companyName ?? args?['companyName'] ?? ''; // 👈 fixed key
    isActive =
        widget.isActive ??
        args?['isActive'] ??
        true; // 👈 add — was missing from args entirely
    memberTill =
        widget.memberTill ??
        args?['memberTill'] ??
        ''; // 👈 add — was missing from args entirely
    address = widget.address ?? args?['address'] ?? ''; // 👈 fixed key
    profileImageUrl =
        widget.profileImageUrl ??
        args?['profileImageUrl']; // 👈 add — was missing from args entirely

    controller = Get.isRegistered<AllCustomersController>()
        ? Get.find<AllCustomersController>()
        : Get.put(AllCustomersController());

    if (memberId != null && memberId!.isNotEmpty) {
      Future.microtask(() {
        controller.fetchMembershipYears(memberId!);
        controller.fetchMemberWasteCategory(memberId!);
      });
    }
  }

  int? _parseYear(String? yearStr) {
    if (yearStr == null || yearStr.isEmpty) return null;
    final match = RegExp(r'^\d{4}').firstMatch(yearStr);
    return match != null ? int.tryParse(match.group(0)!) : null;
  }

  int? _parseQuarter(String? quarterStr) {
    if (quarterStr == null || quarterStr.isEmpty) return null;
    final match = RegExp(r'\d+').firstMatch(quarterStr);
    return match != null ? int.tryParse(match.group(0)!) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const CustomAppBar(
        title: "Customer Details",
        subtitle: "Full profile & category breakdown",
        showBack: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Identity card — real data once loaded ─────────
              Obx(() {
                final detail = controller.memberCategoryDetail.value;
                return _CustomerIdentityCard(
                  customerId:
                      detail?.memberUserId ??
                      customerId, // 👈 fixed — was always raw `customerId`
                  companyName: detail?.industryName ?? companyName,
                  isActive: detail != null
                      ? detail.memberActiveStatus == 1
                      : isActive,
                  memberTill: detail?.memberTillDate ?? memberTill,
                  address: detail?.plantAddress ?? address,
                  profileImageUrl: detail?.profile ?? profileImageUrl,
                );
              }),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Obx(() {
                    final categoryMaps = controller.memberWasteCategories
                        .map(
                          (c) => {
                            "title": c.categoryTitle,
                            "number": c.categoryNumber,
                            "authorized": c.totalAllocated,
                            "used": c.totalUsed,
                            "unit": c.allocatedQuantityType,
                            "active": true,
                          },
                        )
                        .toList();

                    return WasteCategorySection(
                      title: "Waste Category",
                      subtitle: "Authorized vs used quantity per category",
                      categories: categoryMaps,
                      totalCount: categoryMaps.isEmpty
                          ? null
                          : categoryMaps.length,
                      years: controller.membershipYears,
                      quarters: controller.membershipQuarters,
                      isLoading: controller.isCategoryDetailLoading.value,
                      errorMessage:
                          controller.categoryDetailError.value.isNotEmpty
                          ? controller.categoryDetailError.value
                          : null,
                      onFilterChanged: (year, quarter) {
                        if (memberId == null || memberId!.isEmpty) return;
                        controller.fetchMemberWasteCategory(
                          memberId!,
                          year: _parseYear(year),
                          quarter: _parseQuarter(quarter),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Identity Card
// ══════════════════════════════════════════════════════════════
class _CustomerIdentityCard extends StatelessWidget {
  final String customerId;
  final String companyName;
  final bool isActive;
  final String memberTill;
  final String address;
  final String? profileImageUrl;

  const _CustomerIdentityCard({
    required this.customerId,
    required this.companyName,
    required this.isActive,
    required this.memberTill,
    required this.address,
    this.profileImageUrl,
  });

  String get _initials {
    final trimmed = companyName.trim();
    if (trimmed.isEmpty)
      return "?"; // 👈 add — handles empty/null-ish company name safely

    final words = trimmed.split(RegExp(r'\s+'));
    if (words.length >= 2 && words[0].isNotEmpty && words[1].isNotEmpty) {
      return (words[0][0] + words[1][0]).toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = isActive ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.textfieldBorder.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.bodytextColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
                  image:
                      (profileImageUrl != null && profileImageUrl!.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(profileImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: (profileImageUrl == null || profileImageUrl!.isEmpty)
                    ? Text(
                        _initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: const TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Member Id - $customerId",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 9,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isActive ? "Active" : "Inactive",
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Till $memberTill",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bodytextColor.withOpacity(0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(height: 1, color: AppColors.textfieldBorder.withOpacity(0.6)),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.mapPin,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Plant Address",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lighttextColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bodytextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
