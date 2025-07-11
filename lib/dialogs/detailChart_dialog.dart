import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tuple/tuple.dart';


class DetailChartDialog extends StatefulWidget {
  final String patientId;
  const DetailChartDialog({required this.patientId, super.key});
  @override
  State<DetailChartDialog> createState() => _DetailChartDialogState();
}

class _DetailChartDialogState extends State<DetailChartDialog> {
  String selectedSensor = 'Heart_rate';
  List<Map<String, dynamic>> logList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSensorData();
  }

  Future<void> _fetchSensorData() async {
    final ref = FirebaseDatabase.instance.ref('Health_Data');
    final snapshot = await ref.get();

    List<Map<String, dynamic>> filtered = [];
    if (snapshot.exists && snapshot.value != null) {
      final dynamic value = snapshot.value;
      if (value is Map) {
        filtered = value.values
            .map((e) => Map<String, dynamic>.from(e as Map))
            .where((e) => e['Patient_id'].toString() == widget.patientId)
            .toList();
      } else if (value is List) {
        filtered = value
            .where((e) => e != null)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .where((e) => e['Patient_id'].toString() == widget.patientId)
            .toList();
      }
      // timestamp 오름차순 정렬(차트용)
      filtered.sort((a, b) {
        final ta = DateTime.parse((a['Timestamp'] as String).replaceFirst(' ', 'T'));
        final tb = DateTime.parse((b['Timestamp'] as String).replaceFirst(' ', 'T'));
        return ta.compareTo(tb);
      });
    }

    setState(() {
      logList = filtered;
      isLoading = false;
    });
  }

  // 특정 센서의 (timestamp, value) 리스트 추출
  List<Map<String, dynamic>> _getSensorSeries(String key) {
    return logList
        .where((record) => record[key] != null)
        .map((record) => {
      'timestamp': record['Timestamp'],
      'value': (record[key] as num).toDouble(),
    })
        .toList();
  }

  // temperature 보정 값 얻기 (delta)
  double? _getTemperatureDelta(List<Map<String, dynamic>> data) {
    if (data.isEmpty || logList.isEmpty) return null;
    logList.sort((a, b) => ((b['Score'] ?? 0) as num).compareTo((a['Score'] ?? 0) as num));
    final bestLog = logList.firstWhere((rec) => rec['Temperature'] != null, orElse: () => {});
    if (bestLog.isEmpty) return null;

    final bestDate = (bestLog['Timestamp'] as String).split(' ')[0];
    final bestTempData = data.firstWhere(
            (item) => (item['timestamp'] as String).split(' ')[0] == bestDate,
        orElse: () => {});
    if (bestTempData.isEmpty) return null;

    final bestTemp = (bestTempData['value'] as double);
    final delta = 36.5 - bestTemp;
    return delta;
  }

  // 보정 적용
  List<Map<String, dynamic>> _applyTemperatureDelta(
      List<Map<String, dynamic>> data, double? delta) {
    if (delta == null) return data;
    return data
        .map((item) => {...item, 'value': (item['value'] as double) + delta})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // 센서 시리즈 데이터 준비 (최신 10개만, 오름차순 정렬)
    var sensorData = _getSensorSeries(selectedSensor);
    if (sensorData.length > 10) {
      sensorData = sensorData.sublist(sensorData.length - 10);
    }
    double? tempDelta;

    if (selectedSensor == 'Temperature') {
      // 보정 적용 및 delta 저장
      final result = adjustTemperatureByBestScore(sensorData, logList);
      sensorData = result.item1; // 보정된 데이터
      tempDelta = result.item2;  // delta 값
    }

    // 텍스트뷰(오른쪽)는 최신이 위로(내림차순) 정렬
    final reversedSensorData = List<Map<String, dynamic>>.from(sensorData.reversed);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        height: 600,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Row(
          children: [
            // 왼쪽: 차트
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.only(right: 32),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: sensorData.isEmpty
                      ? const Text('데이터가 없습니다', style: TextStyle(fontSize: 20))
                      : buildSensorLineChart(
                    sensorData,
                    sensorType: selectedSensor,
                  ),
                ),
              ),
            ),
            // 오른쪽: 버튼 및 리스트
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '센서별 상세 데이터',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 센서 선택 버튼 (Spo2 제거)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Heart_rate', 'Temperature']
                        .map((key) => _buildSensorButton(key))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: reversedSensorData.map((entry) {
                        final date = entry['timestamp'];
                        final value = entry['value'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            '$date: ${value.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (selectedSensor == 'Temperature' && tempDelta != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        '※ 최고 건강점수 날을 36.5도로 보정하여 표시합니다.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorButton(String key) {
    final selected = selectedSensor == key;
    return ElevatedButton(
      onPressed: () => setState(() => selectedSensor = key),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : Colors.grey[300],
        foregroundColor: selected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(key, style: const TextStyle(fontSize: 14)),
    );
  }
}




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



Tuple2<List<Map<String, dynamic>>, double?> adjustTemperatureByBestScore(
    List<Map<String, dynamic>> sensorData, List<Map<String, dynamic>> logList) {
  if (sensorData.isEmpty) return Tuple2(sensorData, null);

  double maxScore = double.negativeInfinity;
  int bestIdx = -1;
  for (int i = 0; i < sensorData.length; i++) {
    final String sensorTs = (sensorData[i]['timestamp'] as String).substring(0, 19);
    final matchingLog = logList.firstWhere(
          (item) => (item['Timestamp'] as String).substring(0, 19) == sensorTs && item['Score'] != null,
      orElse: () => {},
    );
    if (matchingLog.isNotEmpty) {
      final double score = (matchingLog['Score'] as num).toDouble();
      if (score > maxScore) {
        maxScore = score;
        bestIdx = i;
      }
    }
  }

  if (bestIdx == -1) return Tuple2(sensorData, null);

  final double bestTemp = (sensorData[bestIdx]['value'] as double);
  final double delta = 36.5 - bestTemp;

  final adjusted = sensorData
      .map((item) => {
    ...item,
    'value': (item['value'] as double) + delta,
  })
      .toList();

  return Tuple2(adjusted, delta);
}


// List<Map<String, dynamic>> adjustTemperatureByBestScore(
//     List<Map<String, dynamic>> sensorData, List<Map<String, dynamic>> logList) {
//   if (sensorData.isEmpty) return sensorData;
//
//   double maxScore = double.negativeInfinity;
//   int bestIdx = -1;
//   for (int i = 0; i < sensorData.length; i++) {
//     final String sensorTs = (sensorData[i]['timestamp'] as String).substring(0, 19);
//     final matchingLog = logList.firstWhere(
//           (item) => (item['Timestamp'] as String).substring(0, 19) == sensorTs && item['Score'] != null,
//       orElse: () => {},
//     );
//     print('[디버그] sensorTs: $sensorTs, matchingLog: ${matchingLog.toString()}');
//     if (matchingLog.isNotEmpty) {
//       final double score = (matchingLog['Score'] as num).toDouble();
//       print('[디버그] 매칭 성공, Score: $score');
//       if (score > maxScore) {
//         maxScore = score;
//         bestIdx = i;
//       }
//     } else {
//       print('[디버그] 매칭 실패');
//     }
//   }
//   print('[결과] 선택된 bestIdx: $bestIdx, maxScore: $maxScore');
//   if (bestIdx != -1) {
//     print('[결과] 기준 timestamp: ${sensorData[bestIdx]['timestamp']}');
//   }
//
//   // 최고 점수의 온도
//   final double bestTemp = (sensorData[bestIdx]['value'] as double);
//   final double delta = 36.5 - bestTemp;
//
//   // 모든 데이터에 delta 적용
//   return sensorData
//       .map((item) => {
//     ...item,
//     'value': (item['value'] as double) + delta,
//   })
//       .toList();
// }


