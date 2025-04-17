// patient_service.dart
// Daily 건강 체크 로직 1. 환자 id 조회하기
// 현재 어떤 숫자를 입력하던 2초 뒤 dialog 종료 (25.04.16)
// TODO: http 파이프라인 뚫기

import 'package:flutter/material.dart';
import '../screens/health_screen.dart'; // 다음 화면 경로는 너 구조에 맞게 조정

Future<void> fetchPatientInfo(BuildContext context, String id) async {
  // 로딩 다이얼로그 표시
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  // (나중에 여기에 실제 HTTP 요청/검증 들어감)
  await Future.delayed(const Duration(seconds: 1));

  // 로딩 닫기
  Navigator.pop(context);

  // 다음 화면으로 전환
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HealthScreen(patientId: id),
    ),
  );
}
