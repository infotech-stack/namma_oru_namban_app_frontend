import 'package:dio/dio.dart';
import 'package:userapp/core/config/env_config.dart';
import 'package:userapp/core/network/interceptors/logging_interceptor.dart';
import 'package:userapp/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:userapp/core/network/interceptors/retry_interceptor.dart';
import 'package:userapp/core/network/token_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        // 🔥 CORRECT: EnvConfig returns milliseconds, Duration expects milliseconds
        connectTimeout: Duration(milliseconds: EnvConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: EnvConfig.receiveTimeout),
        sendTimeout: const Duration(seconds: 30), // Optional: add send timeout
        // Additional options for better debugging
        validateStatus: (status) {
          return status! < 500; // Consider 400-499 as valid responses
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    // Add default headers
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Add interceptors
    dio.interceptors.add(TokenInterceptor());
    dio.interceptors.add(RefreshTokenInterceptor(dio));
    dio.interceptors.add(RetryInterceptor(dio));
    dio.interceptors.add(LoggingInterceptor());
  }
}
