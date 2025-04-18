import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 580,
        height: 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _input = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: '고유번호를 입력하세요',
                  hintStyle: TextStyle(fontSize: 36, color: Colors.grey[500]),
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8)
                ],
              ),
            )
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
