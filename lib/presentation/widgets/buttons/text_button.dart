import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class TextAccentButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? color;
  final double? height;
  const TextAccentButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.color,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height ?? 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color ?? Theme.of(context).colorScheme.tertiary,
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
