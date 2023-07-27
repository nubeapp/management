import 'package:flutter/material.dart';
import 'package:validator/presentation/widgets/calendar.dart';

class EditEventScreen extends StatelessWidget {
  const EditEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Calendar(month: 7, year: 2023)],
      ),
    );
  }
}
