// import 'package:flutter/material.dart';
//
// import '../theme/app_color.dart';
//
// class CoordinatePicker extends StatefulWidget {
//   const CoordinatePicker({super.key});
//
//   @override
//   State<CoordinatePicker> createState() => _CoordinatePickerState();
// }
//
// class _CoordinatePickerState extends State<CoordinatePicker> {
//   final List<Map<String, double>> _rectangles = [];
//   Offset? _startPoint;
//
//   void _handleTap(TapDownDetails details) {
//     final pos = details.localPosition;
//
//     setState(() {
//       if (_startPoint == null) {
//         _startPoint = pos;
//       } else {
//         final left = _startPoint!.dx < pos.dx ? _startPoint!.dx : pos.dx;
//         final top = _startPoint!.dy < pos.dy ? _startPoint!.dy : pos.dy;
//         final right = _startPoint!.dx > pos.dx ? _startPoint!.dx : pos.dx;
//         final bottom = _startPoint!.dy > pos.dy ? _startPoint!.dy : pos.dy;
//
//         _rectangles.add({
//           'left': left,
//           'top': top,
//           'right': right,
//           'bottom': bottom,
//           'width': right - left,
//           'height': bottom - top,
//         });
//
//         print('room_${_rectangles.length - 1}: '
//             '{left: $left, top: $top, width: ${right - left}, height: ${bottom - top}}');
//
//         _startPoint = null;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     /*
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('사각형 좌표 수집기'),
//         backgroundColor: Colors.black,
//       ),
//       body: Center(
//         child: GestureDetector(
//           onTapDown: _handleTap,
//           child: Stack(
//             children: [
//               Image.asset("assets/images/floor.png"),
//               // 사각형 + 텍스트 렌더링
//               ..._rectangles.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 Map<String, double> rect = entry.value;
//                 return Stack(
//                   children: [
//                     Positioned(
//                       left: rect['left'],
//                       top: rect['top'],
//                       width: rect['width'],
//                       height: rect['height'],
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.red, width: 2),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: rect['left']! + 4,
//                       top: rect['top']! + 4,
//                       child: Text(
//                         'room_${index + 1}',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                           backgroundColor: Colors.white70,
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//               if (_startPoint != null)
//                 Positioned(
//                   left: _startPoint!.dx - 5,
//                   top: _startPoint!.dy - 5,
//                   child: Container(
//                     width: 10,
//                     height: 10,
//                     decoration: const BoxDecoration(
//                       color: Colors.blue,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         child: const Icon(Icons.list),
//         onPressed: () {
//           for (var i = 0; i < _rectangles.length; i++) {
//             final r = _rectangles[i];
//             print('room_${i + 1}: {left: ${r['left']}, top: ${r['top']}, width: ${r['width']}, height: ${r['height']}}');
//           }
//         },
//       ),
//     );
//     */
//     return Scaffold(
//       backgroundColor: ColorChart.back, // 배경 색상 예시
//       appBar: AppBar(
//         title: const Text('좌표 수집기'),
//         backgroundColor: ColorChart.back,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0), // 바깥 테두리 마진
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(color: Colors.green, width: 2),
//           ),
//           child: Center(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 // 도면 이미지 최대 사이즈는 부모 크기 안에서 제한
//                 final maxWidth = constraints.maxWidth - 32;
//                 final maxHeight = constraints.maxHeight - 32;
//
//                 return Center(
//                   child: GestureDetector(
//                     onTapDown: _handleTap,
//                     child: Stack(
//                       children: [
//                         Image.asset(
//                           'assets/images/floor.png',
//                           width: maxWidth,
//                           height: maxHeight,
//                           fit: BoxFit.contain,
//                         ),
//                         ..._rectangles.asMap().entries.map((entry) {
//                           final rect = entry.value;
//                           return Positioned(
//                             left: rect['left'],
//                             top: rect['top'],
//                             width: rect['width'],
//                             height: rect['height'],
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.red, width: 2),
//                               ),
//                               child: Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Text(
//                                   'room_${entry.key + 1}',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.red,
//                                     backgroundColor: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         if (_startPoint != null)
//                           Positioned(
//                             left: _startPoint!.dx - 5,
//                             top: _startPoint!.dy - 5,
//                             child: Container(
//                               width: 10,
//                               height: 10,
//                               decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:auto_healthbot/theme/app_color.dart';
import 'package:flutter/material.dart';

class CoordinatePicker extends StatefulWidget {
  const CoordinatePicker({super.key});

  @override
  State<CoordinatePicker> createState() => _CoordinatePickerState();
}

class _CoordinatePickerState extends State<CoordinatePicker> {
  final GlobalKey _stackKey = GlobalKey();
  final List<Map<String, double>> _rectangles = [];
  Offset? _startPoint;

  void _handleTap(TapDownDetails details) {
    final RenderBox box =
    _stackKey.currentContext!.findRenderObject() as RenderBox;
    final local = box.globalToLocal(details.globalPosition); // Stack 내부 좌표
    final size = box.size;

    setState(() {
      if (_startPoint == null) {
        _startPoint = local;
      } else {
        final start = _startPoint!;
        final end = local;

        final left = start.dx < end.dx ? start.dx : end.dx;
        final top = start.dy < end.dy ? start.dy : end.dy;
        final right = start.dx > end.dx ? start.dx : end.dx;
        final bottom = start.dy > end.dy ? start.dy : end.dy;

        final leftRatio = left / size.width;
        final topRatio = top / size.height;
        final widthRatio = (right - left) / size.width;
        final heightRatio = (bottom - top) / size.height;

        _rectangles.add({
          'left': leftRatio,
          'top': topRatio,
          'width': widthRatio,
          'height': heightRatio,
        });

        print('room_${_rectangles.length}: '
            '{left: ${leftRatio.toStringAsFixed(4)}, '
            'top: ${topRatio.toStringAsFixed(4)}, '
            'width: ${widthRatio.toStringAsFixed(4)}, '
            'height: ${heightRatio.toStringAsFixed(4)}}');

        _startPoint = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorChart.back,
      appBar: AppBar(
        title: const Text('좌표 수집기'),
        backgroundColor: ColorChart.back,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: ColorChart.back,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: _handleTap,
                  child: Stack(
                    key: _stackKey,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Image.asset(
                          'assets/images/floor.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      ..._rectangles.asMap().entries.map((entry) {
                        final i = entry.key;
                        final r = entry.value;
                        return Positioned(
                          left: r['left']! * constraints.maxWidth,
                          top: r['top']! * constraints.maxHeight,
                          width: r['width']! * constraints.maxWidth,
                          height: r['height']! * constraints.maxHeight,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'room_${i + 1}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.list),
        onPressed: () {
          for (var i = 0; i < _rectangles.length; i++) {
            final r = _rectangles[i];
            print('room_${i + 1}: '
                '{left: ${r['left']}, top: ${r['top']}, width: ${r['width']}, height: ${r['height']}}');
          }
        },
      ),
    );
  }
}
