import 'package:auto_healthbot/theme/app_color.dart';
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
                          child: _buildChart(score: latestScore),
                        ),
                      ),


                      SizedBox(
                        width: 550,
                        height: 175,
                        child: ElevatedButton(
                          onPressed: () {},
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
                              return _recordCard(
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

  Widget _buildChart({required int score}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 420,
          height: 420,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.1416),
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 70,
              backgroundColor: ColorChart.back,
              valueColor: AlwaysStoppedAnimation<Color>(
                getHealthColor(score)
              ),
            ),
          ),
        ),
        Text(
          '건강 점수\n${score}점',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w700,
              color: getHealthColor(score)
          ),
        ),
      ],
    );
  }

  Widget _recordCard({
    required String date,
    required int score,
    required String issue,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: getHealthColor(score),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: const TextStyle(fontSize: 24)),
          Text('건강점수: $score점', style: const TextStyle(fontSize: 24)),
          Text('주요 이슈: $issue', style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }


  Color getHealthColor(int score) {
    if (score <= 30) {
      return ColorChart.red; // 빨강
    } else if (score <= 60) {
      return ColorChart.orange; // 주황
    } else if (score <= 80) {
      return ColorChart.green; // 초록
    } else {
      return ColorChart.blue; // 파랑
    }
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