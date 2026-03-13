import 'package:dio/dio.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'dart:convert';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info('\n═══════════════════════════════════════');
    AppLogger.info('🚀 REQUEST: ${options.method} ${options.path}');
    AppLogger.info('═══════════════════════════════════════');

    if (options.data != null) {
      _printFormattedJson('Request Body', options.data);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // AppLogger.info('\n═══════════════════════════════════════');
    AppLogger.info(
      '✅ RESPONSE: ${response.statusCode} ${response.statusMessage}',
    );
    AppLogger.info('📍 ${response.realUri}');
    // AppLogger.info('═══════════════════════════════════════');

    if (response.data != null) {
      _printFormattedJson('Response Body', response.data);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('\n═══════════════════════════════════════');
    AppLogger.error('❌ ERROR: ${err.message}');
    AppLogger.error('📍 ${err.requestOptions.uri}');
    AppLogger.error('═══════════════════════════════════════');

    if (err.response?.data != null) {
      _printFormattedJson('Error Details', err.response?.data, isError: true);
    }
    handler.next(err);
  }

  // 🔥 Clean JSON printer - NO extra lines between JSON!
  void _printFormattedJson(String title, dynamic data, {bool isError = false}) {
    try {
      if (data == null) return;

      // Format JSON
      String jsonString;
      if (data is String) {
        try {
          final decoded = jsonDecode(data);
          const encoder = JsonEncoder.withIndent('  ');
          jsonString = encoder.convert(decoded);
        } catch (e) {
          jsonString = data;
        }
      } else if (data is Map || data is List) {
        const encoder = JsonEncoder.withIndent('  ');
        jsonString = encoder.convert(data);
      } else {
        jsonString = data.toString();
      }

      // Print as ONE log call — no per-line splitting = no borders between lines
      if (isError) {
        AppLogger.error('📦 $title\n$jsonString');
      } else {
        AppLogger.info('📦 $title\n$jsonString');
      }
    } catch (e) {
      if (isError) {
        AppLogger.error('📦 $title\n$data');
      } else {
        AppLogger.info('📦 $title\n$data');
      }
    }
  }
}
