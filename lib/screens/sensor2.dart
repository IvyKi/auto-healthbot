import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_healthbot/screens/health_screen.dart';

class Sensor2 extends StatefulWidget {
  const Sensor2({super.key});

  @override
  State<Sensor2> createState() => _SensorLoadingScreenState();
}

class _SensorLoadingScreenState extends State<Sensor2> {
  @override
  void initState() {
    super.initState();
    // 3초 후 HealthScreen으로 이동 (측정 완료 가정)
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HealthScreen(patientId: '12345678'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 600,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(strokeWidth: 6),
              ),
              SizedBox(height: 30),
              Text(
                '생체 데이터를 취득중입니다\n손을 떼지 말아주세요',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}