import 'package:contol_officer_app/Modules/Reports/districtDetailCard.dart';
import 'package:contol_officer_app/ReusableWidgets/barChart.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:flutter/material.dart';

class Districtreport extends StatefulWidget {
  const Districtreport({super.key});

  @override
  State<Districtreport> createState() => _DistrictreportState();
}

class _DistrictreportState extends State<Districtreport> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 📊 BAR CHART CARD
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textfieldBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "District-wise Overview",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Q4 2024 quarters",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.bodytextColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            _legendDot(AppColors.Container4),
                            const SizedBox(width: 6),
                            Text(
                              "Limit (kg)",
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    AppColors.bodytextColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _legendDot(AppColors.primary),
                            const SizedBox(width: 6),
                            const Text(
                              "Used (kg)",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.bodytextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: AppColors.textfieldBorder),
                const SizedBox(height: 12),

                // 📊 BAR CHART
                DistrictBarChart(
                  districts: ["Nashik", "Pune", "Mumbai", "Nagpur"],
                  limitValues: [100, 38, 45, 35],
                  usedValues: [200, 160, 90, 78],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          //  DISTRICT LIST CARDS
          DistrictDetailCard(
            district: "Nashik",
            customers: "45",
            manifests: "156",
            capacityUsage: "85%",
            onViewTap: () {},
          ),
          DistrictDetailCard(
            district: "Pune",
            customers: "38",
            manifests: "132",
            capacityUsage: "78%",
            onViewTap: () {},
          ),
          DistrictDetailCard(
            district: "Mumbai",
            customers: "28",
            manifests: "98",
            capacityUsage: "92%",
            onViewTap: () {},
          ),
          DistrictDetailCard(
            district: "Nagpur",
            customers: "16",
            manifests: "64",
            capacityUsage: "71%",
            onViewTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
