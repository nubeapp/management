import 'dart:developer';

import 'package:flutter/material.dart';

@immutable
class Logger {
  Logger();

  final String now = DateTime.now().toString().substring(0, 23);

  Logger.debug(String msg) {
    log('\x1B[37m $now ⌛️ $msg \x1B[0m');
  }

  Logger.info(String msg) {
    log('\x1B[32m $now ✅ $msg \x1B[0m');
  }

  Logger.warning(String msg) {
    log('\x1B[33m $now 🚧 $msg \x1B[0m');
  }

  Logger.error(String msg) {
    log('\x1B[31m $now ❌ $msg \x1B[0m');
  }
}
