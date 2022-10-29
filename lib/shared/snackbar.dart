import 'package:flutter/material.dart';

ScaffoldFeatureController commonSnackbar(String text, BuildContext context,
    {double textSize = 16.0}) {
  const double rad = 15.0;
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: TextStyle(fontSize: textSize),
    ),
    padding: const EdgeInsets.all(18.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rad)),
  ));
}
