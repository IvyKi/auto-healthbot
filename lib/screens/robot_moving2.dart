import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import 'home_screen.dart';

class RobotMoving2 extends StatefulWidget {
  const RobotMoving2({super.key});

  @override
  State<RobotMoving2> createState() => _RobotMoving2State();
}

class _RobotMoving2State extends State<RobotMoving2> {
  @override
  void initState() {
    super.initState();
    // 3초 후 HealthScreen으로 이동 (측정 완료 가정)
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
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
          // Expanded(
          //   child: Image.asset(
          //     'assets/images/robot.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Expanded(
            child: Center(
              child: Text(
                '목적지에 도착하였습니다.\n안내를 종료합니다.',
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
