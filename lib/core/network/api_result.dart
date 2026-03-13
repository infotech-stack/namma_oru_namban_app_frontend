// lib/core/network/api_result.dart
// ════════════════════════════════════════════════════════════════
//  API RESULT
//  Wraps success data OR failure error + exception + code
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_exception.dart';

class ApiResult<T> {
  final T? data;
  final String? error;
  final ApiException? exception;
  final String? code; // 'NOT_REGISTERED' | 'ALREADY_REGISTERED' | etc.

  ApiResult.success(this.data) : error = null, exception = null, code = null;

  ApiResult.failure(this.error, {this.exception, this.code}) : data = null;

  // ── Checks ────────────────────────────────────────────────────
  bool get isSuccess => error == null;
  bool get isFailure => !isSuccess;

  bool get isUnauthorized => exception?.type == ApiErrorType.unauthorized;
  bool get isNoInternet => exception?.type == ApiErrorType.noInternet;
  bool get isTimeout => exception?.type == ApiErrorType.timeout;
  bool get isServerError => exception?.type == ApiErrorType.serverError;
  bool get isTooManyRequests => exception?.type == ApiErrorType.tooManyRequests;

  // ── Code checks (auth flow) ───────────────────────────────────
  bool get isNotRegistered => code == 'NOT_REGISTERED';
  bool get isAlreadyRegistered => code == 'ALREADY_REGISTERED';

  @override
  String toString() => isSuccess
      ? 'ApiResult.success($data)'
      : 'ApiResult.failure($error, code: $code)';
}
