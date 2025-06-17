
import 'dart:convert';
// import 'package:auto_healthbot/screens/robot_moving2.dart';
import 'package:auto_healthbot/theme/app_color.dart';
import 'package:flutter/material.dart';

import '../services/mqtt_service.dart';


class RobotMoving1 extends StatefulWidget {
  const RobotMoving1({super.key});

  @override
  State<RobotMoving1> createState() => _RobotMoving1State();
}

class _RobotMoving1State extends State<RobotMoving1> {
  late MqttService mqtt;

  // @override
  // void initState(){
  //   super.initState();
  //
  //   Future.delayed(Duration(seconds: 5), (){
  //     if (mounted){
  //       Navigator.pushReplacementNamed(context, '/arrived');
  //     }
  //   });
  // }


  @override
  void initState() {
    super.initState();

    mqtt = MqttService();
    mqtt.connect().then((_) {
      mqtt.subscribeToArrivedTopic((message) {
        try {
          final decoded = jsonDecode(message);
          if (decoded["status"] == "arrived") {
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, '/arrived');
          }
        } catch (e) {
          print("📛 메시지 파싱 오류: $e");
        }
      });
    }).catchError((e) {
      print("❌ MQTT 연결 중 오류 발생: $e");
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
      body: Row(
        children: [
          Expanded(
            child: Image.asset(
              'assets/images/robot.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '목적지로\n이동 중입니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
