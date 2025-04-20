import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget buildSensorLineChart(Map<String, Map<String, double>> data) {
  // 각 센서별 색상 정의
  final sensorColors = {
    'Heart_rate': Colors.red,
    'Temperature': Colors.orange,
    'Spo2': Colors.green,
    'Breath': Colors.blue,
    'ECG': Colors.purple,
  };

  // x축: 날짜 순서 → int 인덱스로 매핑
  final xLabels = <String>{};
  data.values.forEach((sensorMap) {
    xLabels.addAll(sensorMap.keys);
  });
  final sortedDates = xLabels.toList()..sort(); // 문자열 날짜 정렬
  final dateToX = {for (var i = 0; i < sortedDates.length; i++) sortedDates[i]: i.toDouble()};

  // 센서별 spots 생성
  final lines = data.entries.map((entry) {
    final sensor = entry.key;
    final values = entry.value;

    final spots = values.entries.map((e) {
      final x = dateToX[e.key]!;
      final y = e.value;
      return FlSpot(x, y);
    }).toList();

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      barWidth: 2,
      color: sensorColors[sensor],
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }).toList();

  return LineChart(
    LineChartData(
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx >= 0 && idx < sortedDates.length) {
                return Text(sortedDates[idx].substring(5)); // '04-18'
              }
              return const Text('');
            },
            reservedSize: 40,
          ),
        ),
      ),
      lineBarsData: lines,
      borderData: FlBorderData(show: true),
      gridData: FlGridData(show: true),
      minY: 0,
    ),
  );
}
