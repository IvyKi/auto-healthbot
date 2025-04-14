import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:auto_healthbot/theme/app_color.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Gradients1.color1,
                Gradients1.color2,
                Gradients1.color3,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 300,),

                Text(
                  '화면을 터치하여 시작하세요',
                  style: TextStyle(
                    fontSize: 128,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}