import 'package:auto_healthbot/theme/app_color.dart';
import 'package:auto_healthbot/utils.dart';
import 'package:flutter/material.dart';


class HealthChart extends StatelessWidget {
  final int score;

  const HealthChart({required this.score, super.key});

  @override
  Widget build(BuildContext context) {
    final color = getHealthColor(score);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 340,
          height: 340,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.1416),
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 70,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        Text(
          '건강 점수\n${score}점',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}