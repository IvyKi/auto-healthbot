import 'package:flutter/material.dart';

import '../dialogs/patient_dialog.dart';



void showPatientLookupDialog(BuildContext context, Function(String) onConfirm) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PatientLookupDialog(onConfirm: onConfirm),
  );
}