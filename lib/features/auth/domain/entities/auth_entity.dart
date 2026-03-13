// lib/features/auth/domain/entities/auth_entity.dart
// ════════════════════════════════════════════════════════════════
//  AUTH ENTITIES — Domain Layer
//  Pure Dart — no fromJson/toJson
// ════════════════════════════════════════════════════════════════

// ── User Entity ───────────────────────────────────────────────
class UserEntity {
  final int id;
  final String mobile;
  final String role;
  final bool isActive;
  final String? name; // optional — register flow la varum

  const UserEntity({
    required this.id,
    required this.mobile,
    required this.role,
    required this.isActive,
    this.name,
  });

  @override
  String toString() =>
      'UserEntity(id: $id, mobile: $mobile, role: $role, name: $name)';
}

// ── Token Entity ──────────────────────────────────────────────
class TokenEntity {
  final String accessToken;
  final String refreshToken;
  final String expiresIn;

  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  @override
  String toString() =>
      'TokenEntity(access: ${accessToken.substring(0, 20)}...)';
}

// ── Send OTP Entity ───────────────────────────────────────────
class SendOtpEntity {
  final String mobile;
  final int expiresIn;
  final String? otp; // dev mode only
  final String? code; // 'NOT_REGISTERED' | 'ALREADY_REGISTERED'

  const SendOtpEntity({
    required this.mobile,
    required this.expiresIn,
    this.otp,
    this.code,
  });
}

// ── Verify OTP Entity ─────────────────────────────────────────
class VerifyOtpEntity {
  final bool isNewUser;
  final String type; // 'login' | 'register'
  final UserEntity user;
  final TokenEntity tokens;

  const VerifyOtpEntity({
    required this.isNewUser,
    required this.type,
    required this.user,
    required this.tokens,
  });
}
