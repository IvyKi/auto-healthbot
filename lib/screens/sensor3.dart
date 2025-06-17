import 'dart:async';
import 'package:auto_healthbot/screens/health_screen.dart';
import 'package:auto_healthbot/theme/app_color.dart';
import 'package:flutter/material.dart';

class Sensor3 extends StatefulWidget {
  final String patientId;

  const Sensor3({super.key, required this.patientId});


  @override
  State<Sensor3> createState() => _Sensor3State();
}

class _Sensor3State extends State<Sensor3> {
  @override
  void initState() {
    super.initState();
    // 3초 후 HealthScreen으로 이동 (측정 완료 가정)
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HealthScreen(patientId: widget.patientId),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorChart.back,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 400, // 원하는 너비
                height: 400, // 원하는 높이
                child: Image.asset(
                  'assets/images/save.png',
                  fit: BoxFit.contain, // 원본 비율 유지하며 맞춤
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '데이터 취득을 완료했습니다!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 64,
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
