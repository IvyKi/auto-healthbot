import 'package:flutter/material.dart';

class CoordinatePicker extends StatefulWidget {
  const CoordinatePicker({super.key});

  @override
  State<CoordinatePicker> createState() => _CoordinatePickerState();
}

class _CoordinatePickerState extends State<CoordinatePicker> {
  final List<Offset> _points = [];

  void _addPoint(TapDownDetails details) {
    final Offset localPos = details.localPosition;

    setState(() {
      _points.add(localPos);
    });

    print('좌표 저장됨: x=${localPos.dx.toStringAsFixed(2)}, y=${localPos.dy.toStringAsFixed(2)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('좌표 수집 도구'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: GestureDetector(
          onTapDown: _addPoint,
          child: Stack(
            children: [
              Image.asset("assets/images/floor.png"),
              ..._points.map((point) => Positioned(
                left: point.dx - 5,
                top: point.dy - 5,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.list),
        onPressed: () {
          for (var i = 0; i < _points.length; i++) {
            final p = _points[i];
            print('room_$i: {left: ${p.dx.toStringAsFixed(2)}, top: ${p.dy.toStringAsFixed(2)}}');
          }
        },
      ),
    );
  }
}
