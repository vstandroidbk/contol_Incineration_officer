import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class Categorydis extends StatelessWidget {
  const Categorydis({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textfieldBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and date range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Waste Category Distribution',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.bodytextColor,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Q4 2024',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.bodytextColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(thickness: 1, color: AppColors.textfieldBorder),
          const SizedBox(height: 6),
          usageRow('Biomedical Waste', 20, 44),
          usageRow('Industrial Waste', 60, 33),
          usageRow('Chemical Waste', 52, 28),
          usageRow('Other Usage', 8, 10),
        ],
      ),
    );
  }

  Widget usageRow(String label, int manifests, int precentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.bodytextColor,
                ),
              ),
              Text(
                '$manifests manifests ($precentage %)',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.bodytextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.textfieldBorder,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    height: 6,
                    width: constraints.maxWidth * (precentage / 100),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
