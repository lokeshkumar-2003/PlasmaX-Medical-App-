import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BloodGroupChart extends StatelessWidget {
  final Map<String, int> bloodGroup;

  const BloodGroupChart({super.key, required this.bloodGroup});

  List<BarChartGroupData> getBarChartGroups(Map<String, int> bloodGroup) {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
              toY: bloodGroup["A+"]?.toDouble() ?? 0,
              color: Colors.green,
              width: 20)
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
              toY: bloodGroup["B+"]?.toDouble() ?? 0,
              color: Colors.blue,
              width: 20)
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
              toY: bloodGroup["AB+"]?.toDouble() ?? 0,
              color: Colors.orange,
              width: 20)
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
              toY: bloodGroup["O+"]?.toDouble() ?? 0,
              color: Colors.yellow,
              width: 20)
        ],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
              toY: bloodGroup["A-"]?.toDouble() ?? 0,
              color: Colors.purple,
              width: 20)
        ],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(
              toY: bloodGroup["B-"]?.toDouble() ?? 0,
              color: Colors.red,
              width: 20)
        ],
      ),
      BarChartGroupData(
        x: 6,
        barRods: [
          BarChartRodData(
              toY: bloodGroup["AB-"]?.toDouble() ?? 0,
              color: Colors.pink,
              width: 20)
        ],
      ),
      BarChartGroupData(
        x: 7,
        barRods: [
          BarChartRodData(
              toY: bloodGroup["O-"]?.toDouble() ?? 0,
              color: Colors.brown,
              width: 20)
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: getBarChartGroups(bloodGroup),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget:
                  bottomTitles, // Assuming bottomTitles is a function
              reservedSize: 28,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barTouchData: BarTouchData(enabled: false),
      ),
    );
  }
}

Widget bottomTitles(double value, TitleMeta meta) {
  const titles = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
  return Text(
    titles[value.toInt()],
    style: TextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
  );
}
