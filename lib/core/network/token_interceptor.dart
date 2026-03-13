import 'package:dio/dio.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/storage/secure_storage_service.dart';

class TokenInterceptor extends Interceptor {
  final SecureStorageService storage = SecureStorageService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    AppLogger.info("🚀 ${options.method} → ${options.path}");

    handler.next(options);
  }
}
