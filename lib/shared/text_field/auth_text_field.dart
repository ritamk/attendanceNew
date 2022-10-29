import 'package:flutter/material.dart';

InputDecoration authTextInputDecoration(String label, IconData suffixIcon) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(20.0),
    fillColor: Colors.grey.shade300,
    filled: true,
    prefixIcon: Icon(suffixIcon),
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: textFieldBorder(),
    focusedBorder: textFieldBorder(),
    errorBorder: textFieldBorder(),
  );
}

OutlineInputBorder textFieldBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(30.0),
  );
}
