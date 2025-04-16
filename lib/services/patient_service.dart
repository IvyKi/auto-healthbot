// patient_service.dart
// Daily 건강 체크 로직 1. 환자 id 조회하기
// 현재 어떤 숫자를 입력하던 2초 뒤 dialog 종료 (25.04.16)
// TODO: http 파이프라인 뚫기

import 'package:flutter/material.dart';

Future<void> fetchPatientInfo(BuildContext context, id) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  await Future.delayed(Duration(seconds: 2)); // 나중에 실제 http로 대체

  Navigator.pop(context); // 로딩 닫기

  // 추후 처리: Navigator.push(...) 등
}
