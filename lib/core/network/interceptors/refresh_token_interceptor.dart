import 'package:dio/dio.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/storage/secure_storage_service.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService storage = SecureStorageService();

  bool _isRefreshing = false;

  RefreshTokenInterceptor(this.dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await storage.getRefreshToken();

        final response = await dio.post(
          "/auth/refresh",
          data: {"refreshToken": refreshToken},
        );

        final newToken = response.data["token"];

        await storage.saveToken(newToken);

        AppLogger.info("🔄 Token refreshed");

        final request = err.requestOptions;

        request.headers["Authorization"] = "Bearer $newToken";

        final retryResponse = await dio.fetch(request);

        return handler.resolve(retryResponse);
      } catch (e) {
        await storage.clear();
        AppLogger.error("❌ Refresh token failed");

        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    }

    return handler.next(err);
  }
}
