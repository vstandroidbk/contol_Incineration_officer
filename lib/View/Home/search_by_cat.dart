import 'package:contol_officer_app/Controller/homecontroller.dart';
import 'package:contol_officer_app/widgets/app_bar.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:contol_officer_app/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class SearchByCategory extends StatefulWidget {
  const SearchByCategory({super.key});

  @override
  State<SearchByCategory> createState() => _SearchByCategoryState();
}

class _SearchByCategoryState extends State<SearchByCategory> {
  final TextEditingController _controller = TextEditingController();
  final MemberController memberController = Get.put(MemberController());

  @override
  void initState() {
    super.initState();
    Future.microtask(() => memberController.fetchCategorySummary());
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
      appBar: const CustomAppBar(
        title: "Search by Category",
        subtitle: "Browse members by waste category",
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
                hintText: "Search category name or number",
                icon: LucideIcons.search,
                autofocus: true,
                onChanged: (val) => memberController.searchCategories(val),
              ),

              const SizedBox(height: 18),

              Obx(() {
                if (memberController.isCategoryLoading.value) {
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
                        "${memberController.categories.length} categories",
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
                  if (memberController.isCategoryLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (memberController.categoryErrorMessage.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        memberController.categoryErrorMessage.value,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  if (memberController.categories.isEmpty) {
                    return Center(
                      child: Text(
                        "No categories found",
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
                    itemCount: memberController.categories.length,
                    itemBuilder: (context, index) {
                      final c = memberController.categories[index];
                      return _CategoryTile(
                        title: c.categoryTitle,
                        number: c.categoryNumber,
                        memberCount: c.memberCount,
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

class _CategoryTile extends StatelessWidget {
  final String title;
  final String number;
  final int memberCount;

  const _CategoryTile({
    required this.title,
    required this.number,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textfieldBorder.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.bodytextColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.container4.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.container4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.bodytextColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "$memberCount members",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lighttextColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            size: 16,
            color: AppColors.lighttextColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
