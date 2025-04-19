import 'dart:async';
import 'package:auto_healthbot/screens/health_screen.dart';
import 'package:auto_healthbot/screens/sensor3.dart';
import 'package:auto_healthbot/theme/app_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Sensor2 extends StatefulWidget {
  const Sensor2({super.key});

  @override
  State<Sensor2> createState() => _Sensor2State();
}

class _Sensor2State extends State<Sensor2> {
  @override
  void initState() {
    super.initState();
    // 3초 후 HealthScreen으로 이동 (측정 완료 가정)
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Sensor3(),
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
