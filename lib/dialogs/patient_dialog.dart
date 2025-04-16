import 'package:flutter/material.dart';

class PatientLookupDialog extends StatefulWidget {
  final Function(String patientId) onConfirm;

  const PatientLookupDialog({required this.onConfirm, super.key});

  @override
  State<PatientLookupDialog> createState() => _PatientLookupDialogState();
}

class _PatientLookupDialogState extends State<PatientLookupDialog> {
  String _input = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      title: Text(
        '환자 조회',
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 620,
        height: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 70,),

            Text('고유번호를 입력하세요.', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) {
                setState(() {
                  _input = value;
                });
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                isDense: true,
              ),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),

      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
            widget.onConfirm(_input);    // 콜백 호출
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('조회'),
        ),
      ],
    );
  }
}
