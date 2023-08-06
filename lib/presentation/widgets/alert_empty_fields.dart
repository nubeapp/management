import 'package:flutter/material.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/widgets/button.dart';

class AlertConfirmDialog extends StatefulWidget {
  const AlertConfirmDialog({super.key});

  @override
  State<AlertConfirmDialog> createState() => _AlertConfirmDialogState();
}

class _AlertConfirmDialogState extends State<AlertConfirmDialog> {
  void _dismissWithValue(bool value) {
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Are you sure you want to delete the event? This action can not be undone',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Button.black(text: 'Cancel', width: context.w * 0.35, onPressed: () => _dismissWithValue(false)),
              Button.red(text: 'Delete', width: context.w * 0.35, onPressed: () => _dismissWithValue(true)),
            ],
          )
        ],
      ),
    );
  }
}
