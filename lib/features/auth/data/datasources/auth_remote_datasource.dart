// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:userapp/core/network/api_constants.dart';
import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/auth/data/model/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel request);
  Future<SendOtpResponseModel> registerSendOtp(
    RegisterSendOtpRequestModel request,
  );
  Future<VerifyOtpResponseModel> verifyOtp(VerifyOtpRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _api;

  AuthRemoteDataSourceImpl({ApiService? apiService})
    : _api = apiService ?? ApiService();

  // ── LOGIN Send OTP ────────────────────────────────────────────
  // POST /api/v1/user/auth/send-otp
  // 404 NOT_REGISTERED → success:false, code:'NOT_REGISTERED' return pannuvom
  @override
  Future<SendOtpResponseModel> sendOtp(SendOtpRequestModel request) async {
    final result = await _api.post(ApiConstants.auth.sendOtp, request.toJson());

    if (result.isSuccess && result.data != null) {
      return SendOtpResponseModel.fromJson(result.data as Map<String, dynamic>);
    }

    // 404 NOT_REGISTERED — throw பண்ணாம model return pannuvom
    // Repository la code check pannuvom
    if (result.exception?.statusCode == 404) {
      return SendOtpResponseModel(
        success: false,
        message:
            result.error ??
            'Mobile number not registered. Please register first.',
        code: 'NOT_REGISTERED',
      );
    }

    throw ApiException(
      message: result.error ?? 'Failed to send OTP. Please try again.',
      type: result.exception?.type ?? ApiErrorType.unknown,
      statusCode: result.exception?.statusCode,
    );
  }

  // ── REGISTER Send OTP ──────────────────────────────────────────
  // POST /api/v1/user/auth/register/send-otp
  // 409 ALREADY_REGISTERED → success:false, code:'ALREADY_REGISTERED' return pannuvom
  @override
  Future<SendOtpResponseModel> registerSendOtp(
    RegisterSendOtpRequestModel request,
  ) async {
    final result = await _api.post(
      ApiConstants.auth.registerSendOtp,
      request.toJson(),
    );

    if (result.isSuccess && result.data != null) {
      return SendOtpResponseModel.fromJson(result.data as Map<String, dynamic>);
    }

    // 409 ALREADY_REGISTERED
    if (result.exception?.statusCode == 409) {
      return SendOtpResponseModel(
        success: false,
        message:
            result.error ??
            'Mobile number already registered. Please login instead.',
        code: 'ALREADY_REGISTERED',
      );
    }

    throw ApiException(
      message: result.error ?? 'Failed to send OTP. Please try again.',
      type: result.exception?.type ?? ApiErrorType.unknown,
      statusCode: result.exception?.statusCode,
    );
  }

  // ── Verify OTP ────────────────────────────────────────────────
  @override
  Future<VerifyOtpResponseModel> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    final result = await _api.post(
      ApiConstants.auth.verifyOtp,
      request.toJson(),
    );

    if (result.isSuccess && result.data != null) {
      return VerifyOtpResponseModel.fromJson(
        result.data as Map<String, dynamic>,
      );
    }

    throw ApiException(
      message: result.error ?? 'Invalid OTP. Please try again.',
      type: result.exception?.type ?? ApiErrorType.unknown,
      statusCode: result.exception?.statusCode,
    );
  }
}
