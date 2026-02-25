import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 2,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  static void info(String message) => _logger.i(message);

  static void error(String message, [StackTrace? stackTrace]) =>
      _logger.e(message, stackTrace: stackTrace);

  static void warning(String message) => _logger.w(message);
}
