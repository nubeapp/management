import 'package:flutter/material.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/widgets/button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Button.black(
          text: 'Open',
          width: context.w * 0.2,
          onPressed: () => showDialog(
            barrierColor: Colors.black12,
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              content: Container(
                width: context.w * 0.4,
                height: context.h * 0.4,
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent.withOpacity(0.8),
                ),
                child: Column(
                  children: [
                    Button.black(
                      text: 'Back',
                      width: context.w * 0.3,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
