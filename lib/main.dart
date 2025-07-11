import 'package:auto_healthbot/screens/robot_moving1.dart';
import 'package:auto_healthbot/screens/robot_moving2.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Bot App',
        theme: ThemeData(
          fontFamily: 'NotoSansKR', // << 전체 시스템 기본 폰트 지정
          textTheme: ThemeData.light().textTheme.copyWith(
            bodyMedium: TextStyle(fontSize: 16),
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      home: SplashScreen(),
      routes: {
        '/moving': (_) => RobotMoving1(),
        '/arrived': (_) => RobotMoving2(),
      },

      // home: CoordinatePicker()
    );
  }
}
