class StorageKeys {
  // Box names
  static const String settingsBox = "settings_box";
  static const String userBox = "user_box"; // 🔥 NEW

  // Settings
  static const String languageCode = "language_code";

  // User details
  static const String userId = "user_id";
  static const String userMobile = "user_mobile";
  static const String userName = "user_name";
  static const String userEmail = "user_email";
  static const String userRole = "user_role";
  static const String userIsActive = "user_is_active";
  static const String userProfileImage = "user_profile_image";
  // Add this in storage_keys.dart
  static const String isNewUser = "is_new_user";

  // Tokens
  static const String accessToken = "access_token";
  static const String refreshToken = "refresh_token";

  // App state
  static const String isLoggedIn = "is_logged_in";
  static const String lastLoginTime = "last_login_time";
  static const String hasLaunched = "has_launched";
}
