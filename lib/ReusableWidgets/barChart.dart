import 'package:contol_officer_app/utils/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DistrictBarChart extends StatelessWidget {
  final List<String> districts;
  final List<double> limitValues;
  final List<double> usedValues;

  const DistrictBarChart({
    super.key,
    required this.districts,
    required this.limitValues,
    required this.usedValues,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${districts[groupIndex]}\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: rod.toY.round().toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                );
              },
            ),
          ),

          gridData: FlGridData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: List.generate(
              6, // number of lines depending on your max value
              (i) {
                double yValue = i * 40; // interval 40

                return HorizontalLine(
                  y: yValue,
                  color: Colors.grey.withOpacity(0.3),
                  strokeWidth: 1,
                  dashArray: [6, 4],
                );
              },
            ),
          ),

          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 40,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= districts.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      districts[index],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          barGroups: List.generate(
            districts.length,
            (i) => BarChartGroupData(
              x: i,
              barsSpace: 5,
              barRods: [
                // Blue bar — Limit
                BarChartRodData(
                  toY: limitValues[i],
                  width: 18,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  color: AppColors.Container4,
                ),
                // Green bar — Used
                BarChartRodData(
                  toY: usedValues[i],
                  width: 18,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
