import 'dart:async';
import 'package:auto_healthbot/screens/home_screen.dart';
import 'package:auto_healthbot/screens/robot_moving2.dart';
import 'package:auto_healthbot/theme/app_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class RobotMoving1 extends StatefulWidget {
  const RobotMoving1({super.key});

  @override
  State<RobotMoving1> createState() => _RobotMoving1State();
}

class _RobotMoving1State extends State<RobotMoving1> {
  @override
  void initState() {
    super.initState();
    // 3초 후 HealthScreen으로 이동 (측정 완료 가정)
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RobotMoving2(),
        ),
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
