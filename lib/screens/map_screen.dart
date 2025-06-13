import 'package:auto_healthbot/dialogs/destination_dialog.dart';
import 'package:flutter/material.dart';
import '../models/room_box.dart';
import '../services/room_data_loader.dart';
import '../theme/app_color.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<RoomBox> _roomBoxes = [];

  @override
  void initState() {
    super.initState();
    loadRoomBoxes().then((value) {
      setState(() {
        _roomBoxes = value;
      });
    });
  }

  void _handleTap(BuildContext context, TapDownDetails details, double width, double height) {
    final dxRatio = details.localPosition.dx / width;
    final dyRatio = details.localPosition.dy / height;

    for (final box in _roomBoxes) {
      if (box.contains(dxRatio, dyRatio)) {
        _showConfirmDialog(context, box.room);
        break;
      }
    }
  }

  void _showConfirmDialog(BuildContext context, String room) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => DestinationConfirmDialog(
          room: room,
          onConfirm: () {
            Navigator.pushNamed(context, "/navigation");
          }
      )
    );
  }



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
              return GestureDetector(
                onTapDown: (details) =>
                    _handleTap(context, details, constraints.maxWidth, constraints.maxHeight),
                child: Stack(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Image.asset(
                        "assets/images/floor.png",
                        fit: BoxFit.contain,
                      ),
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

