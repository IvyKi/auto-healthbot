import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


Widget buildSensorLineChart(
    List<Map<String, dynamic>> data, {
      String sensorType = 'Heart_rate',
    }) {
  if (data.isEmpty) {
    return const Center(child: Text('데이터가 없습니다'));
  }

  final xLabels = <int, String>{};
  final spots = <FlSpot>[];

  for (int i = 0; i < data.length; i++) {
    final item = data[i];
    final dateTime = DateTime.parse((item['timestamp'] as String).replaceFirst(' ', 'T'));
    final label = "${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    xLabels[i] = label;
    spots.add(FlSpot(i.toDouble(), (item['value'] as double)));
  }

  double minY = 0, maxY = 100;
  Color lineColor = Colors.blue;
  switch (sensorType) {
    case 'Heart_rate':
      minY = 40;
      maxY = 140;
      lineColor = Colors.red;
      break;
    case 'Temperature':
      minY = 32;
      maxY = 42;
      lineColor = Colors.orange;
      break;
    default:
      minY = 0;
      maxY = 100;
      lineColor = Colors.blue;
  }

  return LineChart(
    LineChartData(
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1, // 데이터 포인트 위치에만 라벨을 출력
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (xLabels.containsKey(idx)) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Transform.rotate(
                    angle: -0.5, // 시인성 개선 (약 -30도)
                    child: Text(
                      xLabels[idx]!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            reservedSize: 42,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 위쪽 축 숨김
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 오른쪽 축 숨김
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 2,
          color: lineColor,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      borderData: FlBorderData(show: true),
      gridData: FlGridData(show: true),
      minY: minY,
      maxY: maxY,

    ),
  );
}


// 보정 함수
List<Map<String, dynamic>> adjustTemperatureByBestScore(
    List<Map<String, dynamic>> sensorData, List<Map<String, dynamic>> logList) {
  if (sensorData.isEmpty) return sensorData;

  // sensorData 내에서 가장 건강점수가 높은 날짜 찾기
  double maxScore = double.negativeInfinity;
  int bestIdx = -1;
  for (int i = 0; i < sensorData.length; i++) {
    // 해당 날짜의 timestamp
    final String sensorTs = sensorData[i]['timestamp'];
    // logList에서 같은 timestamp 찾기
    final log = logList.firstWhere(
          (item) => item['Timestamp'] == sensorTs,
      orElse: () => {},
    );
    if (log.isNotEmpty && log['Score'] != null) {
      final double score = (log['Score'] as num).toDouble();
      if (score > maxScore) {
        maxScore = score;
        bestIdx = i;
      }
    }
  }

  if (bestIdx == -1) return sensorData; // 해당 기간 내 점수 데이터 없음

  // 최고 점수의 온도
  final double bestTemp = (sensorData[bestIdx]['value'] as double);
  final double delta = 36.5 - bestTemp;

  // 모든 데이터에 delta 적용
  return sensorData
      .map((item) => {
    ...item,
    'value': (item['value'] as double) + delta,
  })
      .toList();
}