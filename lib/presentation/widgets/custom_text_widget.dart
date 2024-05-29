import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tripster/utils/constants.dart';

class CircularTextWithBorder extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color borderColor;
  final double borderWidth;

  const CircularTextWithBorder({
    Key? key,
    required this.text,
    this.fontSize = 16.0,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
