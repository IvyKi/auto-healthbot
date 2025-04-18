import 'package:auto_healthbot/screens/sensor1.dart';
import 'package:auto_healthbot/theme/app_color.dart';
import 'package:auto_healthbot/widgets/health_chart.dart';
import 'package:auto_healthbot/widgets/record_card.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class HealthScreen extends StatelessWidget {
  final String patientId;

  const HealthScreen({required this.patientId, super.key});

  @override
  Widget build(BuildContext context) {
    final records = _getMockRecords();
    final int latestScore = records.first['score'];

    return Scaffold(
      backgroundColor: ColorChart.back,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 70),
            child: Row(
              children: [


                // 왼쪽: 차트 + 버튼
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: HealthChart(score: latestScore),
                        ),
                      ),


                      SizedBox(
                        width: 550,
                        height: 160,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Sensor1()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorChart.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: const BorderSide( // ✅ 윤곽선 설정!
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'Daily 건강 점수 측정하기',
                            style: TextStyle(fontSize: 40, fontWeight:FontWeight.w500, color: ColorChart.back),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 40),

                // 오른쪽: 기록 + 버튼
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9), // 배경보다 살짝 어두운 톤
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: ListView.builder(
                            itemCount: records.length.clamp(0, 10),
                            itemBuilder: (context, index) {
                              final record = records[index];
                              return RecordCard(
                                date: record['date']!,
                                score: record['score']!,
                                issue: record['issue']!,
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 40,),

                      SizedBox(
                        width: 340,
                        height: 85,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorChart.back,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: const BorderSide( // ✅ 윤곽선 설정!
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: const Text('세부 차트 조회',
                              style: TextStyle(fontSize: 40, fontWeight:FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 좌상단 뒤로가기 버튼
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 36, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }




  List<Map<String, dynamic>> _getMockRecords() {
    return [
      {
        'date': '2025년 04월 17일',
        'score': 90,
        'issue': '전체적으로 건강해요',
      },
      {
        'date': '2025년 04월 16일',
        'score': 60,
        'issue': '체온이 높아요',
      },
      {
        'date': '2025년 04월 15일',
        'score': 30,
        'issue': '수면이 불안정해요',
      },
      {
        'date': '2025년 04월 17일',
        'score': 80,
        'issue': '전체적으로 건강해요',
      },
      {
        'date': '2025년 04월 16일',
        'score': 60,
        'issue': '체온이 높아요',
      },
      {
        'date': '2025년 04월 15일',
        'score': 30,
        'issue': '수면이 불안정해요',
      },
    ];
  }
}