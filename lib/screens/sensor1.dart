import 'dart:async';
import 'package:auto_healthbot/screens/sensor2.dart';
import 'package:auto_healthbot/theme/app_color.dart';
import 'package:flutter/material.dart';

class Sensor1 extends StatefulWidget {
  const Sensor1({super.key});

  @override
  State<Sensor1> createState() => _Sensor1State();
}

class _Sensor1State extends State<Sensor1> {
  @override
  void initState() {
    super.initState();
    // 2초 후 자동으로 다음 화면으로 이동 (센서 인식 가정)
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Sensor2()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorChart.back,
      body: Row(
        children: [
          Expanded(
            child: Image.asset(
              'assets/images/finger.png',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '센서에 손을\n접촉해주세요',
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