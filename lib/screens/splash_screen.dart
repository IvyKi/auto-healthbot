import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 전체 화면 터치 감지
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            '화면을 터치하여 시작하세요',
            style: TextStyle(color: Colors.white70, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
