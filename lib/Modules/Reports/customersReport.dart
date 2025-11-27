import 'package:contol_officer_app/Modules/Reports/allCustomers.dart';
import 'package:contol_officer_app/Modules/Reports/categoryDis.dart';
import 'package:contol_officer_app/Modules/Reports/customerGrid.dart';
import 'package:contol_officer_app/ReusableWidgets/lineChart.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Customersreport extends StatefulWidget {
  const Customersreport({super.key});

  @override
  State<Customersreport> createState() => _CustomersreportState();
}

class _CustomersreportState extends State<Customersreport> {
  final List<FlSpot> line1 = [
    FlSpot(0, 40),
    FlSpot(1, 75),
    FlSpot(2, 55),
    FlSpot(3, 90),
    FlSpot(4, 80),
  ];

  final List<FlSpot> line2 = [
    FlSpot(0, 60),
    FlSpot(1, 50),
    FlSpot(2, 65),
    FlSpot(3, 70),
    FlSpot(4, 95),
  ];

  final List<String> months = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 🔷 CUSTOMER GRID
          CustomerGridItem(),
              const SizedBox(height: 20),
          // 📊 MONTHLY TRENDS CARD
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textfieldBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Monthly Trends",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Q4 2024 quarters",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.bodytextColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.textfieldBorder),
                const SizedBox(height: 20),

                // LINE CHART
                MonthlyTrendChart(
                  line1Spots: line1,
                  line2Spots: line2,
                  months: months,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Categorydis(),
            const SizedBox(height: 16),

          Allcustomers(),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(LucideIcons.download),
              label: const Text(
                "Export Usage Reports",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          
        ],
      ),
    );
  }
}
