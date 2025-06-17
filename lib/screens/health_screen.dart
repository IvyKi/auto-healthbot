import 'package:auto_healthbot/screens/sensor1.dart';
import 'package:auto_healthbot/theme/app_color.dart';
import 'package:auto_healthbot/widgets/health_chart.dart';
import 'package:auto_healthbot/widgets/record_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../dialogs/detailChart_dialog.dart';
import '../services/mqtt_service.dart';
import 'home_screen.dart';

class HealthScreen extends StatefulWidget {
  final String patientId;

  const HealthScreen({required this.patientId, super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  String patientName = '';
  String patientGender = '';
  late MqttService mqtt;

  @override
  void initState() {
    super.initState();
    _fetchPatientInfo();

    mqtt = MqttService();
    mqtt.connect().then((_) {
      print('✅ MQTT 연결됨 (health_screen)');

      mqtt.subscribeToTopic('sensor/ready', (msg) {
        print('📥 sensor/ready 수신: $msg');
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Sensor1(patientId: widget.patientId),
          ),
        );
      });
    }).catchError((e) {
      print('❌ MQTT 연결 실패: $e');
    });

  }

  Future<void> _fetchPatientInfo() async {
    final ref = FirebaseDatabase.instance.ref('Patient/${widget.patientId}');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        patientName = data['name'] ?? '';
        patientGender = data['gender'] ?? '';
      });
    }
  }

  void _startMeasurement() async {
    await mqtt.publishMessage('sensor/start', 'start'); // 🟢 센서 시작 신호
    print('📤 sensor/start 메시지 전송 완료');
    // 화면 전환은 아직 하지 않음
  }





  @override
  Widget build(BuildContext context) {

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
                      if (patientName.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            '$patientName (${patientGender == "M" ? "남" : "여"})',
                            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                        ),
                      Expanded(
                        child: StreamBuilder<DatabaseEvent>(
                          stream: FirebaseDatabase.instance.ref('Health_Data').onValue,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                              return Center(child: HealthChart(score: 0));
                            }

                            final rawData = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                            final filtered = rawData.values
                                .map((e) => Map<String, dynamic>.from(e))
                                .where((e) => e['Patient_id'].toString() == widget.patientId)
                                .toList();

                            filtered.sort((a, b) => b['Timestamp'].compareTo(a['Timestamp']));

                            final latestScore = filtered.isNotEmpty ? (filtered.first['Score'] ?? 0) : 0;

                            return Center(child: HealthChart(score: latestScore));
                          },
                        ),
                      ),

                      SizedBox(
                        width: 550,
                        height: 85,
                        child: ElevatedButton(
                          onPressed: _startMeasurement,
                          // () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (_) => Sensor1(patientId: widget.patientId)),
                          //   );
                          // },
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
                          // 👇 여기 StreamBuilder로 대체
                          child: StreamBuilder<DatabaseEvent>(
                            stream: FirebaseDatabase.instance.ref('Health_Data').onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) return Text('에러 발생');
                              if (!snapshot.hasData || snapshot.data!.snapshot.value == null)
                                return Center(child: CircularProgressIndicator());

                              final rawData = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                              final filtered = rawData.values
                                  .map((e) => Map<String, dynamic>.from(e))
                                  .where((e) => e['Patient_id'].toString() == widget.patientId)
                                  .toList();

                              filtered.sort((a, b) => b['Timestamp'].compareTo(a['Timestamp']));

                              return ListView.builder(
                                itemCount: filtered.length.clamp(0, 10),
                                itemBuilder: (context, index) {
                                  final record = filtered[index];
                                  return RecordCard(
                                    date: _formatDate(record['Timestamp']),
                                    score: record['Score'] ?? 0,
                                    issue: _getHealthComment(record['Score'] ?? 0),
                                  );
                                },
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => DetailChartDialog(patientId: widget.patientId),
                            );
                          },
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

  String _formatDate(String iso) {
    final dt = DateTime.parse(iso);
    return '${dt.year}년 ${dt.month.toString().padLeft(2, '0')}월 ${dt.day.toString().padLeft(2, '0')}일';
  }

  String _getHealthComment(int score) {
    if (score >= 80) return '전체적으로 건강해요';
    if (score >= 50) return '주의가 필요해요';
    return '의료진 상담을 추천합니다';
  }
}