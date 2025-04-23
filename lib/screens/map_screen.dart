import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: ColorChart.back,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          title: Text("목적지 설정",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Colors.black
            ),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 40),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Gradients1.color3, // 연한 녹색 테두리
              width: 5,
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Stack(
            children: [
              Image.asset("assets/images/floor.png"),
              // ... 목적지 핀 Positioned 등 추가 ...
            ],
          ),
        )
        ,
      )
    );
  }
}

