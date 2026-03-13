// lib/core/network/api_service.dart
// ════════════════════════════════════════════════════════════════
//  API SERVICE — Updated
//  All HTTP methods + proper ApiException wrapping
// ════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/core/network/dio_client.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  // ── GET ───────────────────────────────────────────────────────
  Future<ApiResult<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final res = await _dio.get(path, queryParameters: queryParams);
      return ApiResult.success(res.data);
    } on DioException catch (e, s) {
      AppLogger.error('GET $path', s);
      final ex = ApiException.fromDioException(e);
      return ApiResult.failure(ex.message, exception: ex);
    } catch (e, s) {
      AppLogger.error('GET $path unknown', s);
      return ApiResult.failure(e.toString());
    }
  }

  // ── POST ──────────────────────────────────────────────────────
  Future<ApiResult<dynamic>> post(
    String path,
    dynamic data, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final res = await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
      );
      return ApiResult.success(res.data);
    } on DioException catch (e, s) {
      AppLogger.error('POST $path', s);
      final ex = ApiException.fromDioException(e);
      return ApiResult.failure(ex.message, exception: ex);
    } catch (e, s) {
      AppLogger.error('POST $path unknown', s);
      return ApiResult.failure(e.toString());
    }
  }

  // ── PUT ───────────────────────────────────────────────────────
  Future<ApiResult<dynamic>> put(
    String path,
    dynamic data, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final res = await _dio.put(
        path,
        data: data,
        queryParameters: queryParams,
      );
      return ApiResult.success(res.data);
    } on DioException catch (e, s) {
      AppLogger.error('PUT $path', s);
      final ex = ApiException.fromDioException(e);
      return ApiResult.failure(ex.message, exception: ex);
    } catch (e, s) {
      AppLogger.error('PUT $path unknown', s);
      return ApiResult.failure(e.toString());
    }
  }

  // ── PATCH ─────────────────────────────────────────────────────
  Future<ApiResult<dynamic>> patch(
    String path,
    dynamic data, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final res = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParams,
      );
      return ApiResult.success(res.data);
    } on DioException catch (e, s) {
      AppLogger.error('PATCH $path', s);
      final ex = ApiException.fromDioException(e);
      return ApiResult.failure(ex.message, exception: ex);
    } catch (e, s) {
      AppLogger.error('PATCH $path unknown', s);
      return ApiResult.failure(e.toString());
    }
  }

  // ── DELETE ────────────────────────────────────────────────────
  Future<ApiResult<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final res = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParams,
      );
      return ApiResult.success(res.data);
    } on DioException catch (e, s) {
      AppLogger.error('DELETE $path', s);
      final ex = ApiException.fromDioException(e);
      return ApiResult.failure(ex.message, exception: ex);
    } catch (e, s) {
      AppLogger.error('DELETE $path unknown', s);
      return ApiResult.failure(e.toString());
    }
  }

  // ── MULTIPART upload ──────────────────────────────────────────
  Future<ApiResult<dynamic>> uploadFile(
    String path,
    FormData formData, {
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final res = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(contentType: 'multipart/form-data'),
      );
      return ApiResult.success(res.data);
    } on DioException catch (e, s) {
      AppLogger.error('UPLOAD $path', s);
      final ex = ApiException.fromDioException(e);
      return ApiResult.failure(ex.message, exception: ex);
    } catch (e, s) {
      AppLogger.error('UPLOAD $path unknown', s);
      return ApiResult.failure(e.toString());
    }
  }
}
