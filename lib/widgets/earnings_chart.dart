import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EarningsChart extends StatelessWidget {
  final List<FlSpot> estimatedEarnings;
  final List<FlSpot> actualEarnings;
  final List<String> dates; 

  const EarningsChart({
    super.key,
    required this.estimatedEarnings,
    required this.actualEarnings,
    required this.dates,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 0.8,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      return index >= 0 && index < dates.length
                          ? SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                dates[index],
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                    interval: 1,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.max) return Container();
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          meta.formattedValue,
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: estimatedEarnings,
                  color: Colors.blue,
                  barWidth: 2,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  spots: actualEarnings,
                  color: Colors.green,
                  barWidth: 2,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withOpacity(0.1),
                  ),
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
