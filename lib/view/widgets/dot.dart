import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final Color borderColor;
  final Color color;

  const Dot({Key? key, required this.color, required this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.0,
      width: 15.0,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            width: 1.2,
            color: borderColor,
          )),
    );
  }
}
