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
            color: ColorChart.back,
            border: Border.all(
              color: Gradients1.color3,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final maxHeight = constraints.maxHeight;

              return GestureDetector(
                onTapDown: (details) {
                  final localPosition = details.localPosition;
                  final dxRatio = localPosition.dx / maxWidth;
                  final dyRatio = localPosition.dy / maxHeight;

                  print("터치 비율: dx = ${dxRatio.toStringAsFixed(4)}, dy = ${dyRatio.toStringAsFixed(4)}");

                  // → 다음 단계에서 이 비율 좌표와 터치박스 좌표 리스트 비교
                },
                child: Stack(
                  children: [
                    SizedBox(
                      width: maxWidth,
                      height: maxHeight,
                      child: Image.asset("assets/images/floor.png", fit: BoxFit.contain),
                    ),
                    // 이후 마커 및 터치박스 표시 추가
                  ],
                ),
              );
            },
          ),
        ),
      )
    );
  }
}

