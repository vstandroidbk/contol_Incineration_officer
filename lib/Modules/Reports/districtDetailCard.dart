import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DistrictDetailCard extends StatelessWidget {
  final String district;
  final String customers;
  final String manifests;
  final String capacityUsage;
  final VoidCallback? onViewTap;

  const DistrictDetailCard({
    super.key,
    required this.district,
    required this.customers,
    required this.manifests,
    required this.capacityUsage,
    this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textfieldBorder),
      ),
      child: Column(
        children: [
          // LEFT SIDE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Row(
                children: [
                  Icon(
                    LucideIcons.mapPin,
                    size: 22,
                    color: AppColors.Container4,
                  ),
                  const SizedBox(width: 10),

                  // District info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        district,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "$customers Customers",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.bodytextColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              ElevatedButton.icon(
                onPressed: onViewTap,
                icon: const Icon(
                  LucideIcons.eye,
                  size: 16,
                  color: Colors.white,
                ),
                label: const Text(
                  "View",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size.zero, // keeps button compact
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),

          // RIGHT SIDE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // manifests + usage
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Manifests", style: TextStyle( fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bodytextColor.withOpacity(0.6),)),
                  Text(
                    manifests,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
             
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Capacity Usage", style: TextStyle( fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bodytextColor.withOpacity(0.6),)),
                  Text(
                    capacityUsage,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
