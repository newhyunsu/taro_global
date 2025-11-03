import 'dart:io';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart'; // kDebugMode 사용

class AppLogger {
  static final Logger _logger = Logger(
    printer: (FunctionLogger()),
    level: kDebugMode ? Level.debug : Level.info,
  );

  static void d(String message) => _logger.d(message);
  static void i(String message) => _logger.i(message);
  static void w(String message) => _logger.w(message);
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}

class FunctionLogger extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final now = DateTime.now();
    final formattedTime =
        "${now.hour}:${now.minute}:${now.second}.${now.millisecond}";

    final stackTrace = StackTrace.current.toString().split("\n");
    final regExp = RegExp(r'#\d+\s+([^\s]+) \((.+?):(\d+):\d+\)');

    String functionName = "Unknown";
    String fileName = "Unknown";

    // "logger.dart" 관련 프레임 제외하고 실제 호출한 부분 찾기
    for (var line in stackTrace) {
      if (line.contains('logger.dart')) continue; // AppLogger 내부 호출은 무시

      final match = regExp.firstMatch(line);
      if (match != null) {
        functionName = match.group(1) ?? "Unknown";
        fileName =
            match.group(2)?.split(Platform.pathSeparator).last ?? "Unknown";
        break;
      }
    }

    final message =
        "[${event.level.name.toUpperCase()}] [$formattedTime] [$fileName → $functionName] ${event.message}";
    return [message];
  }
}

// 사용법
/*
  AppLogger.d("Debug message");
  AppLogger.i("Info message");
  AppLogger.w("Warning message");
  AppLogger.e("Error message", error, stackTrace);
*/
