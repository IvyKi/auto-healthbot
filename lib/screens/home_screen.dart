// home_screen.dart

import 'package:auto_healthbot/helper/dialog_helper.dart';
import 'package:auto_healthbot/widgets/home_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/patient_service.dart';
import '../widgets/bottom_menu.dart';
import 'splash_screen.dart';
import 'package:auto_healthbot/theme/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
    _inactivityTimer = Timer(Duration(seconds: 30), _goToSplashScreen);
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

      // home screen UI
      child: Scaffold(
        backgroundColor: ColorChart.back,
        body: Padding(
          padding: const EdgeInsets.only(top: 80, left: 80, right: 80),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeButton(
                    labelTop: 'Daily',
                    labelBottom: '건강 체크',
                    color: ColorChart.blue,
                    textColor: ColorChart.back,

                    // Daily 건강 체크 로직의 시작
                    onTap: () {
                      // dialog ui
                      showPatientLookupDialog(context, (patientId){
                        // dialog 환자 id 조회
                        fetchPatientInfo(context, patientId);
                      });
                    },
                  ),
                  HomeButton(
                    labelTop: '목적지',
                    labelBottom: '안내하기',
                    color: Gradients1.color3,
                    textColor: ColorChart.back,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 하단 바 메뉴
              BottomMenu(),
            ],
          ),
        ),
      ),
    );
  }
}
