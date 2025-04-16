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
