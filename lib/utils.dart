import 'package:auto_healthbot/theme/app_color.dart';
import 'package:flutter/material.dart';


Color getHealthColor(int score) {
  if (score <= 30) {
    return ColorChart.red; // 빨강
  } else if (score <= 60) {
    return ColorChart.orange; // 주황
  } else if (score <= 80) {
    return ColorChart.green; // 초록
  } else {
    return ColorChart.blue; // 파랑
  }
}