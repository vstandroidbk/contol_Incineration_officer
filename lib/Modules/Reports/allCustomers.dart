import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Allcustomers extends StatefulWidget {
  const Allcustomers({super.key});

  @override
  State<Allcustomers> createState() => _AllcustomersState();
}

class _AllcustomersState extends State<Allcustomers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "All Customers",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.bodytextColor,
          
          ),
        ),
        const SizedBox(height: 10),

        CustomerCard(
          industryName: "ABC Industries",
          id: "MEM-2024-011",
          manifests: "24",
          wastetype: "Chemical",
          status: "Approved",
          statusBg: AppColors.primary,
          statustext: Colors.white,
          precentage: 90,
          pickupDate: 'Oct 15, 2025',
        ),

        CustomerCard(
          industryName: "Tech Park Ltd",
          id: "MEM-2024-041",
          manifests: "45",
          wastetype: "E-Waste",
          status: "Exceeded",
          statusBg: AppColors.error.withOpacity(0.1),
          statustext: AppColors.error,
          precentage: 105,
          pickupDate: 'Oct 25, 2025',
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}

class CustomerCard extends StatelessWidget {
  final String industryName;
  final String id;
  final String manifests;
  final String wastetype;
  final String status;
  final Color statusBg;
  final Color statustext;
  final int precentage;
  final String pickupDate;

  const CustomerCard({
    super.key,
    required this.industryName,
    required this.id,
    required this.manifests,
    required this.wastetype,
    required this.status,
    required this.statusBg,
    required this.statustext,
    required this.precentage,
    required this.pickupDate,
  });

  bool get isExceeded => status.toLowerCase() == "exceeded";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textfieldBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.file, size: 22, color: AppColors.Container4),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        industryName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.bodytextColor,
                        ),
                      ),
                      Text(
                        id,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.bodytextColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Status Tag
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statustext,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Middle Section Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn("Manifests", manifests),
              _infoColumn("Waste Type", wastetype),
            ],
          ),

          const SizedBox(height: 14),

          // Capacity Usage Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Capacity Usage",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.bodytextColor.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
               Text(
                "$precentage %",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.bodytextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          LayoutBuilder(
            builder: (context, constraints) {
              final double barWidth =
                  constraints.maxWidth * (precentage / 100).clamp(0, 1);

              final Color barColor =
                  precentage >= 100 ? AppColors.error : AppColors.primary;

              return Stack(
                children: [
                  Container(
                    height: 6,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: AppColors.textfieldBorder,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: barWidth,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 14),

          // Pickup + View Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn("Last Pickup:", pickupDate),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.eye, size: 18),
                label: const Text("View History"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.bodytextColor,
                  side: const BorderSide(color: AppColors.textfieldBorder),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          // 🚨 Take Action Button (Only when exceeded)
          if (isExceeded) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary, // Your secondary color
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Take Action",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
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
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.bodytextColor,
          ),
        ),
      ],
    );
  }
}
