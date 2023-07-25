import 'package:flutter/material.dart';
import 'package:validator/extensions/extensions.dart';

@immutable
class Button extends StatelessWidget {
  const Button.black({
    Key? key,
    required this.text,
    this.onPressed,
    required this.width,
  })  : color = Colors.black,
        textColor = Colors.white,
        blocked = false,
        super(key: key);

  const Button.white({
    Key? key,
    required this.text,
    this.onPressed,
    required this.width,
  })  : color = Colors.white,
        textColor = Colors.black87,
        blocked = false,
        super(key: key);

  const Button.blocked({
    Key? key,
    required this.text,
    required this.width,
  })  : onPressed = null,
        color = Colors.black26,
        textColor = Colors.white,
        blocked = true,
        super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final double width;
  final bool blocked;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: context.h * 0.05,
      child: Material(
        color: color, // Apply the background color here
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: InkWell(
          onTap: onPressed,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
