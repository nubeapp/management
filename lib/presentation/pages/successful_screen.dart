import 'package:flutter/material.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/widgets/button.dart';

class SuccessfulScreen extends StatelessWidget {
  const SuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[400],
      body: Center(
        child: Button.black(
          text: 'Back',
          width: context.w * 0.3,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
