import 'package:flutter/material.dart';

import '../widgets/sensor_chart.dart';

class DetailChartDialog extends StatefulWidget {
  final String patientId;

  const DetailChartDialog({required this.patientId, super.key});

  @override
  State<DetailChartDialog> createState() => _DetailChartDialogState();
}

class _DetailChartDialogState extends State<DetailChartDialog> {
  String selectedSensor = 'Heart_rate';

  final Map<String, Map<String, double>> sensorData = {
    'Heart_rate': {
      '2025-04-18': 78.5,
      '2025-04-17': 84.0,
    },
    'Temperature': {
      '2025-04-18': 36.7,
      '2025-04-17': 37.2,
    },
    'Spo2': {
      '2025-04-18': 97.1,
      '2025-04-17': 96.0,
    },
    'Breath': {
      '2025-04-18': 19.2,
      '2025-04-17': 20.1,
    },
    'ECG': {
      '2025-04-18': 0.85,
      '2025-04-17': 0.72,
    },
  };

  @override
  Widget build(BuildContext context) {
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

        child: Row(
          children: [

            // 왼쪽: 전체 센서 꺾은선 차트 (넓게)
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.only(right: 32),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: buildSensorLineChart(sensorData),
                ),
              ),
            ),

            // 오른쪽: 버튼 열 + 세부 값
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 오른쪽 상단: 대제목 + 닫기 버튼
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

                  // 센서 선택 버튼
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sensorData.keys.map((key) => _buildSensorButton(key)).toList(),
                  ),

                  const SizedBox(height: 20),

                  // 세부 텍스트 리스트
                  Expanded(
                    child: ListView(
                      children: sensorData[selectedSensor]!.entries.map((entry) {
                        final date = entry.key;
                        final value = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            '$date: ${value.toString()}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }).toList(),
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
