// ════════════════════════════════════════════════════════════════
// lib/features/auth/domain/usecases/send_otp_usecase.dart
// LOGIN — existing user only
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/auth/domain/entities/auth_entity.dart';
import 'package:userapp/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;
  const SendOtpUseCase(this._repository);

  Future<ApiResult<SendOtpEntity>> call(String mobile) async {
    final cleaned = mobile.trim().replaceAll(' ', '');

    if (cleaned.isEmpty) {
      return ApiResult.failure('Mobile number is required.');
    }

    final isValid = RegExp(r'^(\+91)?[6-9]\d{9}$').hasMatch(cleaned);
    if (!isValid) {
      return ApiResult.failure('Please enter a valid 10-digit mobile number.');
    }

    final result = await _repository.sendOtp(cleaned);

    if (result.isSuccess) {
      AppLogger.info('✅ Login OTP sent');
    } else {
      AppLogger.warning(
        '❌ sendOtp failed: ${result.error} | code: ${result.data?.code}',
      );
    }

    return result;
  }
}

// ════════════════════════════════════════════════════════════════
// lib/features/auth/domain/usecases/register_send_otp_usecase.dart
// REGISTER — new user only
// ════════════════════════════════════════════════════════════════

class RegisterSendOtpUseCase {
  final AuthRepository _repository;
  const RegisterSendOtpUseCase(this._repository);

  Future<ApiResult<SendOtpEntity>> call({
    required String mobile,
    String? name,
  }) async {
    final cleaned = mobile.trim().replaceAll(' ', '');

    if (cleaned.isEmpty) {
      return ApiResult.failure('Mobile number is required.');
    }

    final isValid = RegExp(r'^(\+91)?[6-9]\d{9}$').hasMatch(cleaned);
    if (!isValid) {
      return ApiResult.failure('Please enter a valid 10-digit mobile number.');
    }

    final result = await _repository.registerSendOtp(
      mobile: cleaned,
      name: name?.trim().isEmpty == true ? null : name?.trim(),
    );

    if (result.isSuccess) {
      AppLogger.info('✅ Register OTP sent');
    } else {
      AppLogger.warning(
        '❌ registerSendOtp failed: ${result.error} | code: ${result.data?.code}',
      );
    }

    return result;
  }
}

// ════════════════════════════════════════════════════════════════
// lib/features/auth/domain/usecases/verify_otp_usecase.dart
// VERIFY — both login + register
// ════════════════════════════════════════════════════════════════

class VerifyOtpUseCase {
  final AuthRepository _repository;
  const VerifyOtpUseCase(this._repository);

  Future<ApiResult<VerifyOtpEntity>> call({
    required String mobile,
    required String otp,
  }) async {
    if (mobile.trim().isEmpty) {
      return ApiResult.failure('Mobile number is missing.');
    }

    final cleanedOtp = otp.trim();

    if (cleanedOtp.isEmpty) return ApiResult.failure('Please enter the OTP.');
    if (cleanedOtp.length != 6)
      return ApiResult.failure('OTP must be 6 digits.');
    if (!RegExp(r'^\d{6}$').hasMatch(cleanedOtp)) {
      return ApiResult.failure('OTP must contain numbers only.');
    }

    return _repository.verifyOtp(mobile: mobile.trim(), otp: cleanedOtp);
  }
}
