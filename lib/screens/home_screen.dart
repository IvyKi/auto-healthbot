import 'package:flutter/material.dart';
import 'dart:async';
import '../dialogs/patient_dialog.dart';
import 'splash_screen.dart';
import 'package:auto_healthbot/theme/app_color.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(Duration(seconds: 15), _goToSplashScreen);
  }

  void _goToSplashScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),

      // UI
      child: Scaffold(
        backgroundColor: AppColor.back,
        body: Padding(
          padding: const EdgeInsets.only(top: 80, left: 80, right: 80),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFixedSizeButton(
                    labelTop: 'Daily',
                    labelBottom: '건강 체크',
                    color: AppColor.blue,
                    onTap: () {
                      _showPatientDialog();
                    },
                  ),
                  _buildFixedSizeButton(
                    labelTop: '목적지',
                    labelBottom: '안내하기',
                    color: AppColor.green,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildBottomMenu(),
            ],
          ),
        ),

      ),
    );
  }

  // 메인 2 기능 버튼 박스
  Widget _buildFixedSizeButton({
    required String labelTop,
    required String labelBottom,
    required Color color,
    required VoidCallback onTap,
  }) {
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

  // 환자 고유번호 조회 dialog
  void _showPatientDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PatientLookupDialog(
        onConfirm: (patientId) {
          _fetchPatientInfo(patientId); // 또는 다음 단계 화면 전환
        },
      ),
    );
  }

  void _fetchPatientInfo(String id) async {
    // 로딩 띄우기
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(Duration(seconds: 2)); // 예시 대기

    Navigator.pop(context); // 로딩 닫기

    // 실제 검증 및 화면 전환 처리
    // Navigator.push(...);
  }




  // bottom
  Widget _buildBottomMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _iconWithLabel(Icons.language, '다국어지원'),
          _iconWithLabel(Icons.settings, '관리자 모드'),
          _iconWithLabel(Icons.music_note_outlined, 'TTS ON/OFF'),
        ],
      ),
    );
  }

  Widget _iconWithLabel(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black, size: 60),

        SizedBox(width: 10,),
        Text(label, style: TextStyle(color: Colors.black, fontSize: 40)),
      ],
    );
  }
}
