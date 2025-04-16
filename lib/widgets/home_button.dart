// home_button.dart
// 홈 화면 메인 2가지 기능의 touch box ui 구성

import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class HomeButton extends StatelessWidget {
  final String labelTop;
  final String labelBottom;
  final Color color;
  final VoidCallback onTap;
  final Color textColor;

  const HomeButton({
    required this.labelTop,
    required this.labelBottom,
    required this.color,
    required this.onTap,
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 520,
      height: 578,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (labelTop.isNotEmpty)
                  Text(
                    labelTop,
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: AppColor.back,
                    ),
                  ),
                Text(
                  labelBottom,
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: AppColor.back,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
