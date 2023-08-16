import 'package:flutter/material.dart';

class StatusLabel extends StatelessWidget {
  const StatusLabel({super.key, required this.status, required this.color, required this.textColor});

  final String status;
  final Color color;
  final Color textColor;

  StatusLabel.available({super.key})
      : color = Colors.blue[900]!,
        textColor = Colors.white,
        status = 'AVAILABLE';
  StatusLabel.sold({super.key})
      : color = Colors.yellowAccent[700]!,
        textColor = Colors.black87,
        status = 'SOLD';
  const StatusLabel.validated({super.key})
      : color = Colors.green,
        textColor = Colors.black87,
        status = 'VALIDATED';
  const StatusLabel.canceled({super.key})
      : color = Colors.red,
        textColor = Colors.white,
        status = 'CANCELED';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            status,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}
