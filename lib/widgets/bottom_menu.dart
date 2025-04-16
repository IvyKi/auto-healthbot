// bottom_menu.dart
// 홈 화면 하단 바 메뉴의 연결로직

import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _iconWithLabel(Icons.language, '다국어지원'),
          _iconWithLabel(Icons.settings, '관리자 모드'),
          _iconWithLabel(Icons.music_note_outlined, 'TTS ON/OFF'),
        ]
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
