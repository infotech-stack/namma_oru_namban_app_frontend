import 'package:dio/dio.dart';
import 'package:userapp/core/logger/app_logger.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;

  RetryInterceptor(this.dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      AppLogger.warning("🔁 Network error - retrying request...");

      try {
        await Future.delayed(const Duration(seconds: 2));

        final response = await dio.fetch(err.requestOptions);

        return handler.resolve(response);
      } catch (e) {
        AppLogger.error("❌ Retry failed");

        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
