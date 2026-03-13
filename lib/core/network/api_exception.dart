// lib/core/network/api_exception.dart
// ════════════════════════════════════════════════════════════════
//  API EXCEPTION
//  Converts DioException → readable ApiException
//  Used across User + Driver + Admin apps
// ════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ApiErrorType type;

  const ApiException({
    required this.message,
    this.statusCode,
    this.type = ApiErrorType.unknown,
  });

  // ── Factory: Convert DioException → ApiException ─────────────
  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Connection timed out. Please check your internet.',
          type: ApiErrorType.timeout,
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection. Please try again.',
          type: ApiErrorType.noInternet,
        );

      case DioExceptionType.badResponse:
        return ApiException.fromResponse(e.response);

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled.',
          type: ApiErrorType.cancelled,
        );

      default:
        return ApiException(
          message: e.message ?? 'Something went wrong.',
          type: ApiErrorType.unknown,
        );
    }
  }

  // ── Factory: Parse server error response ──────────────────────
  factory ApiException.fromResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    // Try to extract server message
    String message = _extractMessage(data);

    switch (statusCode) {
      case 400:
        return ApiException(
          message: message.isNotEmpty
              ? message
              : 'Bad request. Please check your input.',
          statusCode: statusCode,
          type: ApiErrorType.badRequest,
        );
      case 401:
        return ApiException(
          message: message.isNotEmpty
              ? message
              : 'Unauthorized. Please login again.',
          statusCode: statusCode,
          type: ApiErrorType.unauthorized,
        );
      case 403:
        return ApiException(
          message: message.isNotEmpty ? message : 'Access denied.',
          statusCode: statusCode,
          type: ApiErrorType.forbidden,
        );
      case 404:
        return ApiException(
          message: message.isNotEmpty ? message : 'Resource not found.',
          statusCode: statusCode,
          type: ApiErrorType.notFound,
        );
      case 409:
        return ApiException(
          message: message.isNotEmpty
              ? message
              : 'Conflict. Resource already exists.',
          statusCode: statusCode,
          type: ApiErrorType.conflict,
        );
      case 422:
        return ApiException(
          message: message.isNotEmpty ? message : 'Validation failed.',
          statusCode: statusCode,
          type: ApiErrorType.validation,
        );
      case 429:
        return ApiException(
          message: message.isNotEmpty
              ? message
              : 'Too many requests. Please slow down.',
          statusCode: statusCode,
          type: ApiErrorType.tooManyRequests,
        );
      case 500:
      case 502:
      case 503:
        return ApiException(
          message: message.isNotEmpty
              ? message
              : 'Server error. Please try again later.',
          statusCode: statusCode,
          type: ApiErrorType.serverError,
        );
      default:
        return ApiException(
          message: message.isNotEmpty ? message : 'Something went wrong.',
          statusCode: statusCode,
          type: ApiErrorType.unknown,
        );
    }
  }

  // ── Extract message from server response body ─────────────────
  static String _extractMessage(dynamic data) {
    if (data == null) return '';
    if (data is Map) {
      // Try common message keys: message, error, msg, detail
      return (data['message'] ??
              data['error'] ??
              data['msg'] ??
              data['detail'] ??
              '')
          .toString();
    }
    if (data is String) return data;
    return '';
  }

  @override
  String toString() => 'ApiException($type, $statusCode): $message';
}

// ── Error Type Enum ───────────────────────────────────────────
enum ApiErrorType {
  timeout,
  noInternet,
  unauthorized,
  forbidden,
  notFound,
  badRequest,
  conflict,
  validation,
  tooManyRequests,
  serverError,
  cancelled,
  unknown,
}
