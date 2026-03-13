// lib/features/auth/data/model/auth_model.dart
// ════════════════════════════════════════════════════════════════
//  AUTH MODELS — Data Layer
//
//  LOGIN FLOW:
//  POST /user/auth/send-otp
//    req:  { "mobile": "9876543210" }
//    res success: { "success": true, "data": { "mobile": "+91...", "expiresIn": 300, "otp": "123456" }}
//    res fail:    { "success": false, "message": "...", "code": "NOT_REGISTERED" }
//
//  REGISTER FLOW:
//  POST /user/auth/register/send-otp
//    req:  { "mobile": "9876543210", "name": "Kumar" }
//    res success: { "success": true, "data": { "mobile": "+91...", "expiresIn": 300 }}
//    res fail:    { "success": false, "message": "...", "code": "ALREADY_REGISTERED" }
//
//  VERIFY OTP (both flows):
//  POST /user/auth/verify-otp
//    req:  { "mobile": "9876543210", "otp": "123456" }
//    res:  { "success": true, "data": { "isNewUser": false, "type": "login", "user": {...}, "tokens": {...} }}
// ════════════════════════════════════════════════════════════════

import 'package:userapp/features/auth/domain/entities/auth_entity.dart';

// ─────────────────────────────────────────────────────────────
//  SEND OTP REQUEST MODEL  (Login)
// ─────────────────────────────────────────────────────────────
class SendOtpRequestModel {
  final String mobile;

  const SendOtpRequestModel({required this.mobile});

  Map<String, dynamic> toJson() => {'mobile': mobile};
}

// ─────────────────────────────────────────────────────────────
//  REGISTER SEND OTP REQUEST MODEL
// ─────────────────────────────────────────────────────────────
class RegisterSendOtpRequestModel {
  final String mobile;
  final String? name;

  const RegisterSendOtpRequestModel({required this.mobile, this.name});

  Map<String, dynamic> toJson() => {
    'mobile': mobile,
    if (name != null && name!.isNotEmpty) 'name': name,
  };
}

// ─────────────────────────────────────────────────────────────
//  SEND OTP RESPONSE MODEL
// ─────────────────────────────────────────────────────────────
class SendOtpResponseModel {
  final bool success;
  final String message;
  final String? code; // 'NOT_REGISTERED' | 'ALREADY_REGISTERED'
  final SendOtpDataModel? data;

  const SendOtpResponseModel({
    required this.success,
    required this.message,
    this.code,
    this.data,
  });

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SendOtpResponseModel(
        success: json['success'] as bool? ?? false,
        message: json['message'] as String? ?? '',
        code: json['code'] as String?,
        data: json['data'] != null
            ? SendOtpDataModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  SendOtpEntity toEntity() => SendOtpEntity(
    mobile: data?.mobile ?? '',
    expiresIn: data?.expiresIn ?? 300,
    otp: data?.otp,
    code: code,
  );
}

class SendOtpDataModel {
  final String mobile;
  final int expiresIn;
  final String? otp; // dev mode only

  const SendOtpDataModel({
    required this.mobile,
    required this.expiresIn,
    this.otp,
  });

  factory SendOtpDataModel.fromJson(Map<String, dynamic> json) =>
      SendOtpDataModel(
        mobile: json['mobile'] as String? ?? '',
        expiresIn: json['expiresIn'] as int? ?? 300,
        otp: json['otp'] as String?,
      );
}

// ─────────────────────────────────────────────────────────────
//  VERIFY OTP REQUEST MODEL
// ─────────────────────────────────────────────────────────────
class VerifyOtpRequestModel {
  final String mobile;
  final String otp;

  const VerifyOtpRequestModel({required this.mobile, required this.otp});

  Map<String, dynamic> toJson() => {'mobile': mobile, 'otp': otp};
}

// ─────────────────────────────────────────────────────────────
//  VERIFY OTP RESPONSE MODEL
// ─────────────────────────────────────────────────────────────
class VerifyOtpResponseModel {
  final bool success;
  final String message;
  final VerifyOtpDataModel? data;

  const VerifyOtpResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResponseModel(
        success: json['success'] as bool? ?? false,
        message: json['message'] as String? ?? '',
        data: json['data'] != null
            ? VerifyOtpDataModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );

  VerifyOtpEntity toEntity() => VerifyOtpEntity(
    isNewUser: data?.isNewUser ?? false,
    type: data?.type ?? 'login',
    user: data!.user.toEntity(),
    tokens: data!.tokens.toEntity(),
  );
}

class VerifyOtpDataModel {
  final bool isNewUser;
  final String type; // 'login' | 'register'
  final UserModel user;
  final TokenModel tokens;

  const VerifyOtpDataModel({
    required this.isNewUser,
    required this.type,
    required this.user,
    required this.tokens,
  });

  factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpDataModel(
        isNewUser: json['isNewUser'] as bool? ?? false,
        type: json['type'] as String? ?? 'login',
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        tokens: TokenModel.fromJson(json['tokens'] as Map<String, dynamic>),
      );
}

// ─────────────────────────────────────────────────────────────
//  USER MODEL
// ─────────────────────────────────────────────────────────────
class UserModel {
  final int id;
  final String mobile;
  final String role;
  final bool isActive;
  final String? name;

  const UserModel({
    required this.id,
    required this.mobile,
    required this.role,
    required this.isActive,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int? ?? 0,
    mobile: json['mobile'] as String? ?? '',
    role: json['role'] as String? ?? 'user',
    isActive: json['isActive'] as bool? ?? true,
    name: json['name'] as String?,
  );

  UserEntity toEntity() => UserEntity(
    id: id,
    mobile: mobile,
    role: role,
    isActive: isActive,
    name: name,
  );
}

// ─────────────────────────────────────────────────────────────
//  TOKEN MODEL
// ─────────────────────────────────────────────────────────────
class TokenModel {
  final String accessToken;
  final String refreshToken;
  final String expiresIn;

  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    accessToken: json['accessToken'] as String? ?? '',
    refreshToken: json['refreshToken'] as String? ?? '',
    expiresIn: json['expiresIn'] as String? ?? '7d',
  );

  TokenEntity toEntity() => TokenEntity(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: expiresIn,
  );
}
