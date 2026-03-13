// lib/features/auth/data/repositories/auth_repository_impl.dart
// ════════════════════════════════════════════════════════════════
//  AUTH REPOSITORY IMPL — Data Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/core/storage/secure_storage_service.dart';
import 'package:userapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:userapp/features/auth/data/model/auth_model.dart';
import 'package:userapp/features/auth/domain/entities/auth_entity.dart';
import 'package:userapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final SecureStorageService _storage;

  AuthRepositoryImpl({
    AuthRemoteDataSource? dataSource,
    SecureStorageService? storage,
  }) : _dataSource = dataSource ?? AuthRemoteDataSourceImpl(),
       _storage = storage ?? SecureStorageService();

  // ── LOGIN Send OTP ────────────────────────────────────────────
  @override
  Future<ApiResult<SendOtpEntity>> sendOtp(String mobile) async {
    try {
      final model = await _dataSource.sendOtp(
        SendOtpRequestModel(mobile: mobile),
      );

      // NOT_REGISTERED → return as failure with code
      if (!model.success || model.code == 'NOT_REGISTERED') {
        return ApiResult.failure(
          model.message,
          code: model.code, // 'NOT_REGISTERED'
        );
      }

      return ApiResult.success(model.toEntity());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  // ── REGISTER Send OTP ──────────────────────────────────────────
  @override
  Future<ApiResult<SendOtpEntity>> registerSendOtp({
    required String mobile,
    String? name,
  }) async {
    try {
      final model = await _dataSource.registerSendOtp(
        RegisterSendOtpRequestModel(mobile: mobile, name: name),
      );

      // ALREADY_REGISTERED → return as failure with code
      if (!model.success || model.code == 'ALREADY_REGISTERED') {
        return ApiResult.failure(
          model.message,
          code: model.code, // 'ALREADY_REGISTERED'
        );
      }

      return ApiResult.success(model.toEntity());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  // ── Verify OTP → save tokens ──────────────────────────────────
  @override
  Future<ApiResult<VerifyOtpEntity>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      final model = await _dataSource.verifyOtp(
        VerifyOtpRequestModel(mobile: mobile, otp: otp),
      );

      if (model.success && model.data != null) {
        // Save tokens to secure storage
        await Future.wait([
          _storage.saveToken(model.data!.tokens.accessToken),
          _storage.saveRefreshToken(model.data!.tokens.refreshToken),
        ]);
      }

      return ApiResult.success(model.toEntity());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }
}
