// lib/features/auth/domain/repositories/auth_repository.dart
// ════════════════════════════════════════════════════════════════
//  AUTH REPOSITORY — Domain Layer (Abstract)
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  /// LOGIN — send OTP to existing user
  /// Returns NOT_REGISTERED error if mobile not found
  Future<ApiResult<SendOtpEntity>> sendOtp(String mobile);

  /// REGISTER — send OTP to new user
  /// Returns ALREADY_REGISTERED error if mobile exists
  Future<ApiResult<SendOtpEntity>> registerSendOtp({
    required String mobile,
    String? name,
  });

  /// VERIFY OTP — both login + register (same endpoint)
  Future<ApiResult<VerifyOtpEntity>> verifyOtp({
    required String mobile,
    required String otp,
  });
}
