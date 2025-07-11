import 'dart:async';
// import 'package:auto_healthbot/screens/health_screen.dart';
import 'package:auto_healthbot/screens/sensor3.dart';
import 'package:auto_healthbot/theme/app_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import '../services/mqtt_service.dart';

class Sensor2 extends StatefulWidget {
  final String patientId ;

  const Sensor2({super.key, required this.patientId});

  @override
  State<Sensor2> createState() => _Sensor2State();
}

class _Sensor2State extends State<Sensor2> {
  late MqttService mqtt;

  @override
  void initState() {
    super.initState();

    mqtt = MqttService();
    mqtt.connect().then((_) {
      print('✅ MQTT 연결됨 (Sensor2)');

      // sensor/done 토픽 구독
      mqtt.subscribeToTopic('sensor/done', (msg) {
        print('📥 sensor/done 수신: $msg');
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Sensor3(patientId: widget.patientId),
          ),
        );
      });
    }).catchError((e) {
      print('❌ MQTT 연결 실패: $e');
    });
  }

  @override
  void dispose() {
    mqtt.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorChart.back,
      body: Column(
        children: [
          const SizedBox(height: 100),

          Flexible(
            fit: FlexFit.loose,
            child: Center(
              child: SpinKitRing(
                color: ColorChart.blue,
                size: 400,
                lineWidth: 60,
                duration: Duration(milliseconds: 3000),
              ),
            ),
          ),

          const SizedBox(height: 100),

          const Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: Text(
              '생체 데이터를 취득중입니다\n손을 떼지 말아주세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
