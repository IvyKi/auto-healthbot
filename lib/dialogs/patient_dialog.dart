import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

class PatientLookupDialog extends StatefulWidget {
  final Function(String patientId) onConfirm;

  const PatientLookupDialog({required this.onConfirm, super.key});

  @override
  State<PatientLookupDialog> createState() => _PatientLookupDialogState();
}

class _PatientLookupDialogState extends State<PatientLookupDialog> {
  String _input = '';
  String? _errorMessage; // 👈 에러 메시지 상태 추가

  Future<void> _checkPatient() async {
    final ref = FirebaseDatabase.instance.ref('Patient/$_input');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      Navigator.of(context).pop();
      widget.onConfirm(_input);
    } else {
      setState(() {
        _errorMessage = '해당 환자 번호가 존재하지 않습니다.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,

      titlePadding: EdgeInsets.only(top: 20, left: 20, right: 8), // 제목 패딩 조정
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '환자 조회',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            iconSize: 32,
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
        ],
      ),
      content: SizedBox(
        width: 580,
        // height: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _input = value;
                      _errorMessage = null; // 입력 바뀌면 에러 메시지 제거
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
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red[600], fontSize: 24),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _input.isEmpty ? null : _checkPatient,
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

