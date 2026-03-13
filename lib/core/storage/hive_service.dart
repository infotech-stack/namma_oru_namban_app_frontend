import 'package:hive_flutter/hive_flutter.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/features/auth/domain/entities/auth_entity.dart'; // Add this
import 'package:userapp/utils/constants/storage_keys.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box _settingsBox;
  late Box _userBox; // 🔥 NEW: Separate box for user data

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters (if using Hive objects)
    // Hive.registerAdapter(UserEntityAdapter());

    _settingsBox = await Hive.openBox(StorageKeys.settingsBox);
    _userBox = await Hive.openBox(StorageKeys.userBox); // 🔥 Open user box

    AppLogger.info("✅ Hive initialized");
  }

  // ---------------- LANGUAGE ----------------
  Future<void> saveLanguage(String code) async {
    await _settingsBox.put(StorageKeys.languageCode, code);
    AppLogger.info("🌍 Language saved: $code");
  }

  String getLanguage() {
    final code = _settingsBox.get(StorageKeys.languageCode, defaultValue: "en");
    return code;
  }

  // ---------------- USER DETAILS (Login/Register Flow) ----------------

  /// Save user details after login/registration
  Future<void> saveUserDetails({
    required int userId,
    required String mobile,
    required String name,
    required String role,
    required bool isNewUser,
    required bool isActive,
    required String accessToken,
    required String refreshToken,
    String? email,
    String? profileImage,
  }) async {
    await _userBox.put(StorageKeys.userId, userId);
    await _userBox.put(StorageKeys.userMobile, mobile);
    await _userBox.put(StorageKeys.userName, name);
    await _userBox.put(StorageKeys.userRole, role);
    await _userBox.put(StorageKeys.isNewUser, isNewUser);
    await _userBox.put(StorageKeys.userIsActive, isActive);
    await _userBox.put(StorageKeys.accessToken, accessToken);
    await _userBox.put(StorageKeys.refreshToken, refreshToken);

    if (email != null) await _userBox.put(StorageKeys.userEmail, email);
    if (profileImage != null)
      await _userBox.put(StorageKeys.userProfileImage, profileImage);

    await _userBox.put(StorageKeys.isLoggedIn, true);
    await _userBox.put(
      StorageKeys.lastLoginTime,
      DateTime.now().toIso8601String(),
    );

    AppLogger.info(
      "✅ User details saved for: $name ($mobile) - isNewUser: $isNewUser",
    );
  }

  /// Save from VerifyOtpEntity
  Future<void> saveUserFromEntity(VerifyOtpEntity entity) async {
    await saveUserDetails(
      userId: entity.user.id,
      mobile: entity.user.mobile,
      name: entity.user.name ?? '', // Make sure UserEntity has name field
      role: entity.user.role,
      isNewUser: entity.isNewUser,
      isActive: entity.user.isActive,
      accessToken: entity.tokens.accessToken,
      refreshToken: entity.tokens.refreshToken,
    );
  }

  /// Get user details as Map
  Map<String, dynamic> getUserDetails() {
    return {
      'userId': _userBox.get(StorageKeys.userId, defaultValue: 0),
      'mobile': _userBox.get(StorageKeys.userMobile, defaultValue: ''),
      'name': _userBox.get(StorageKeys.userName, defaultValue: ''),
      'role': _userBox.get(StorageKeys.userRole, defaultValue: 'user'),
      'isNewUser': _userBox.get(
        StorageKeys.isNewUser,
        defaultValue: true,
      ), // 🔥 ADD

      'isActive': _userBox.get(StorageKeys.userIsActive, defaultValue: false),
      'email': _userBox.get(StorageKeys.userEmail, defaultValue: ''),
      'profileImage': _userBox.get(
        StorageKeys.userProfileImage,
        defaultValue: '',
      ),
      'isLoggedIn': _userBox.get(StorageKeys.isLoggedIn, defaultValue: false),
    };
  }

  /// Get specific user fields
  int getUserId() => _userBox.get(StorageKeys.userId, defaultValue: 0);
  String getUserName() => _userBox.get(StorageKeys.userName, defaultValue: '');
  String getUserMobile() =>
      _userBox.get(StorageKeys.userMobile, defaultValue: '');
  String getUserRole() =>
      _userBox.get(StorageKeys.userRole, defaultValue: 'user');
  bool isUserActive() =>
      _userBox.get(StorageKeys.userIsActive, defaultValue: false);

  // ---------------- TOKENS ----------------
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _userBox.put(StorageKeys.accessToken, accessToken);
    await _userBox.put(StorageKeys.refreshToken, refreshToken);
    AppLogger.info("🔐 Tokens saved");
  }

  String getAccessToken() =>
      _userBox.get(StorageKeys.accessToken, defaultValue: '');
  String getRefreshToken() =>
      _userBox.get(StorageKeys.refreshToken, defaultValue: '');

  // ---------------- LOGIN STATUS ----------------
  bool isLoggedIn() =>
      _userBox.get(StorageKeys.isLoggedIn, defaultValue: false);

  Future<void> setLoggedIn(bool value) async {
    await _userBox.put(StorageKeys.isLoggedIn, value);
  }

  // ---------------- LOGOUT / CLEAR USER ----------------
  Future<void> clearUserDetails() async {
    await _userBox.clear();
    AppLogger.info("🗑️ User details cleared (logout)");
  }

  // ---------------- CORRECT LOGOUT ----------------
  Future<void> logout() async {
    try {
      // Save settings from settings box (not user box)
      final currentLanguage = _settingsBox.get(
        StorageKeys.languageCode,
        defaultValue: "en",
      );
      final hasLaunched = _settingsBox.get(
        StorageKeys.hasLaunched,
        defaultValue: false,
      );

      // Clear user box completely
      await _userBox.clear();

      // Clear settings box if needed, or preserve
      // await _settingsBox.clear(); // Optional - if you want to clear all

      // Restore important settings in settings box
      await _settingsBox.put(StorageKeys.languageCode, currentLanguage);
      await _settingsBox.put(StorageKeys.hasLaunched, hasLaunched);

      // Ensure login status is false in user box
      await _userBox.put(StorageKeys.isLoggedIn, false);

      AppLogger.info("🚪 User logged out, settings preserved");
    } catch (e) {
      AppLogger.error("❌ Logout error: $e");
    }
  }

  // ---------------- CHECK FIRST TIME ----------------
  bool isFirstTime() {
    return !_userBox.containsKey(StorageKeys.hasLaunched);
  }

  Future<void> setLaunched() async {
    await _userBox.put(StorageKeys.hasLaunched, true);
  }
}
