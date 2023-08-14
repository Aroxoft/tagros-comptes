import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class Logger {
  void log(String message);

  void logError(Object error, [StackTrace? stackTrace]);
}

class LoggerImpl implements Logger {
  @override
  void log(String message) {
    debug.log(message);
    if (kDebugMode) {
      print(message);
    }
  }

  @override
  void logError(Object error, [StackTrace? stackTrace]) {
    debug.log(error.toString(), stackTrace: stackTrace);
    if (kDebugMode) {
      print(error);
      if (stackTrace != null) {
        print(stackTrace);
      }
    }
  }
}

class DevLog extends Logger {
  @override
  void log(String message) {
    debug.log(message, level: 800);
  }

  @override
  void logError(Object error, [StackTrace? stackTrace]) {
    debug.log(error.toString(), level: 1000, stackTrace: stackTrace);
  }
}

final loggerProvider = Provider<Logger>((ref) {
  return DevLog();
});
