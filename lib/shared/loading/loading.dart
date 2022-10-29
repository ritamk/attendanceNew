import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.white, this.rad}) : super(key: key);
  final bool white;
  final double? rad;

  @override
  Widget build(BuildContext context) {
    return white
        ? Theme(
            data: ThemeData.dark(), child: const CupertinoActivityIndicator())
        : Theme(
            data: ThemeData.fallback(),
            child: CupertinoActivityIndicator(radius: rad ?? 10.0));
  }
}
