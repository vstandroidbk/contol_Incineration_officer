import 'package:contol_officer_app/View/Customers/all_customer.dart';
import 'package:contol_officer_app/View/Home/search_by_cat.dart';
import 'package:contol_officer_app/View/Home/search_by_pincode.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── By Pincode — full width, primary entry ────────────────
        _SearchEntryCard(
          icon: LucideIcons.mapPin,
          label: "Search by Pincode",
          sublabel: "Find every customer in a district instantly",
          bgColor: AppColors.primary,
          gradient: const [AppColors.gradient1, AppColors.gradient2],
          onTap: () => Get.to(() => const SearchByPincode()),
        ),

        const SizedBox(height: 12),

        // ── By Category / By Members — side by side ────────────────
        Row(
          children: [
            Expanded(
              child: _SearchEntryCard(
                icon: LucideIcons.layoutGrid,
                label: "By Category",
                sublabel: "Browse waste groups",
                bgColor: AppColors.container4,
                compact: true,
                onTap: () => Get.to(() => const SearchByCategory()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SearchEntryCard(
                icon: LucideIcons.users,
                label: "By Members",
                sublabel: "View all customers",
                bgColor: AppColors.secondary,
                compact: true,
                onTap: () => Get.to(() => const AllCustomers()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// Reusable entry card — navigates to a dedicated search screen
// ══════════════════════════════════════════════════════════════
class _SearchEntryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color bgColor;
  final List<Color>? gradient;
  final bool compact;
  final VoidCallback onTap;

  const _SearchEntryCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.bgColor,
    this.gradient,
    this.compact = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.all(compact ? 14 : 16),
        decoration: BoxDecoration(
          gradient: gradient != null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient!,
                )
              : null,
          color: gradient == null ? Colors.white : null,
          borderRadius: BorderRadius.circular(18),
          border: gradient == null
              ? Border.all(color: AppColors.textfieldBorder, width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: gradient != null
                  ? gradient!.first.withOpacity(0.3)
                  : Colors.black.withOpacity(0.04),
              blurRadius: gradient != null ? 14 : 8,
              offset: Offset(0, gradient != null ? 6 : 3),
            ),
          ],
        ),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(icon, color: Colors.white, size: 18),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        size: 16,
                        color: AppColors.lighttextColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bodytextColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lighttextColor.withOpacity(0.8),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          sublabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.arrowRight,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
