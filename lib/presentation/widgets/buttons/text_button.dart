import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tripster/presentation/cubits/auth_cubit/auth_state.dart';

class TextAccentButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? color;
  final double? height;
  final AuthState? state;
  const TextAccentButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.color,
    this.height,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? Theme.of(context).colorScheme.tertiary,
        ),
        child: Center(
          child: state is AuthLoading
              ? SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.background),
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
