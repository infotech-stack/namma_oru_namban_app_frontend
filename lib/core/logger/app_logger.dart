import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

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

  // 🔥 NEW: Print any object as formatted JSON
  static void json(dynamic data, {String title = '📦 JSON Response'}) {
    try {
      final encoder = JsonEncoder.withIndent('  ');
      String prettyJson;

      if (data is String) {
        // If it's a JSON string, decode and re-encode for pretty print
        final dynamic decoded = jsonDecode(data);
        prettyJson = encoder.convert(decoded);
      } else {
        // If it's already a Map/List, convert directly
        prettyJson = encoder.convert(data);
      }

      _logger.i('\n═══════════════════════════════════════');
      _logger.i('🔥 $title');
      _logger.i('═══════════════════════════════════════');

      // Print line by line to maintain formatting
      prettyJson.split('\n').forEach((line) {
        _logger.i(line);
      });

      _logger.i('═══════════════════════════════════════\n');
    } catch (e) {
      _logger.e('❌ Failed to format JSON: $e');
      _logger.i('📦 Raw data: $data');
    }
  }

  // 🔥 NEW: Print API response with details
  static void apiResponse(dynamic data, {int? statusCode, String? url}) {
    try {
      _logger.i('\n═══════════════════════════════════════');
      _logger.i('🌐 API RESPONSE ${statusCode != null ? '[$statusCode]' : ''}');
      if (url != null) _logger.i('📍 URL: $url');
      _logger.i('═══════════════════════════════════════');

      if (data is Map || data is List) {
        final encoder = JsonEncoder.withIndent('  ');
        final prettyJson = encoder.convert(data);
        prettyJson.split('\n').forEach((line) {
          _logger.i(line);
        });
      } else {
        _logger.i('📦 $data');
      }

      _logger.i('═══════════════════════════════════════\n');
    } catch (e) {
      _logger.e('❌ Error printing API response: $e');
      _logger.i('📦 Raw data: $data');
    }
  }

  // 🔥 NEW: Print API request
  static void apiRequest(String method, String url, {dynamic data}) {
    _logger.i('\n═══════════════════════════════════════');
    _logger.i('🚀 API REQUEST - $method');
    _logger.i('═══════════════════════════════════════');
    _logger.i('📍 URL: $url');

    if (data != null) {
      _logger.i('📦 REQUEST BODY:');
      if (data is Map || data is List) {
        final encoder = JsonEncoder.withIndent('  ');
        final prettyJson = encoder.convert(data);
        prettyJson.split('\n').forEach((line) {
          _logger.i(line);
        });
      } else {
        _logger.i('   $data');
      }
    }
    _logger.i('═══════════════════════════════════════\n');
  }

  // 🔥 NEW: Print error with full details
  static void apiError(dynamic error, {int? statusCode, String? url}) {
    _logger.e('\n═══════════════════════════════════════');
    _logger.e('❌ API ERROR ${statusCode != null ? '[$statusCode]' : ''}');
    if (url != null) _logger.e('📍 URL: $url');
    _logger.e('═══════════════════════════════════════');

    if (error is Map || error is List) {
      final encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(error);
      prettyJson.split('\n').forEach((line) {
        _logger.e(line);
      });
    } else {
      _logger.e('❌ $error');
    }

    _logger.e('═══════════════════════════════════════\n');
  }
}
