import 'package:flutter/material.dart';
import 'package:validator/application/services/dependency_injection/dependencies.dart';
import 'package:validator/presentation/pages/pages.dart';

void main() {
  Dependencies.injectDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());
  }
}
