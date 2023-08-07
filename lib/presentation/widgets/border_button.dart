import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/extensions/extensions.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({
    required this.width,
    required this.color,
    required this.onPressed,
    required this.icon,
    Key? key,
  }) : super(key: key);

  const BorderButton.delete({
    required this.width,
    required this.onPressed,
    Key? key,
  })  : color = Colors.red,
        icon = CupertinoIcons.delete_simple,
        super(key: key);

  const BorderButton.search({
    required this.width,
    required this.onPressed,
    Key? key,
  })  : color = Colors.black,
        icon = CupertinoIcons.search,
        super(key: key);

  final double width;
  final Color color;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: context.h * 0.05,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.white, // Apply the background color here
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: InkWell(
          onTap: onPressed,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Center(child: Icon(icon, color: color)),
        ),
      ),
    );
  }
}
