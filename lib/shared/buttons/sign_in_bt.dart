import 'package:flutter/material.dart';

ButtonStyle authSignInBtnStyle() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.red),
    foregroundColor: MaterialStateProperty.all(Colors.white),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
    alignment: Alignment.center,
  );
}
