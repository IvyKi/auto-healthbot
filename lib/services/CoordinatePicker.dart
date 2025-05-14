import 'package:flutter/material.dart';

class CoordinatePicker extends StatefulWidget {
  const CoordinatePicker({super.key});

  @override
  State<CoordinatePicker> createState() => _CoordinatePickerState();
}

class _CoordinatePickerState extends State<CoordinatePicker> {
  final List<Map<String, double>> _rectangles = [];
  Offset? _startPoint;

  void _handleTap(TapDownDetails details) {
    final pos = details.localPosition;

    setState(() {
      if (_startPoint == null) {
        _startPoint = pos;
      } else {
        final left = _startPoint!.dx < pos.dx ? _startPoint!.dx : pos.dx;
        final top = _startPoint!.dy < pos.dy ? _startPoint!.dy : pos.dy;
        final right = _startPoint!.dx > pos.dx ? _startPoint!.dx : pos.dx;
        final bottom = _startPoint!.dy > pos.dy ? _startPoint!.dy : pos.dy;

        _rectangles.add({
          'left': left,
          'top': top,
          'right': right,
          'bottom': bottom,
          'width': right - left,
          'height': bottom - top,
        });

        print('room_${_rectangles.length - 1}: '
            '{left: $left, top: $top, width: ${right - left}, height: ${bottom - top}}');

        _startPoint = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사각형 좌표 수집기'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: GestureDetector(
          onTapDown: _handleTap,
          child: Stack(
            children: [
              Image.asset("assets/images/floor.png"),
              // 사각형 + 텍스트 렌더링
              ..._rectangles.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, double> rect = entry.value;
                return Stack(
                  children: [
                    Positioned(
                      left: rect['left'],
                      top: rect['top'],
                      width: rect['width'],
                      height: rect['height'],
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                    Positioned(
                      left: rect['left']! + 4,
                      top: rect['top']! + 4,
                      child: Text(
                        'room_${index + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          backgroundColor: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                );
              }),
              if (_startPoint != null)
                Positioned(
                  left: _startPoint!.dx - 5,
                  top: _startPoint!.dy - 5,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.list),
        onPressed: () {
          for (var i = 0; i < _rectangles.length; i++) {
            final r = _rectangles[i];
            print('room_${i + 1}: {left: ${r['left']}, top: ${r['top']}, width: ${r['width']}, height: ${r['height']}}');
          }
        },
      ),
    );
  }
}
