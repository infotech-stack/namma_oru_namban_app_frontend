import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:userapp/core/logger/app_logger.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  final _storage = const FlutterSecureStorage();

  static const _tokenKey = "auth_token";
  static const _refreshKey = "refresh_token";

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    AppLogger.info("🔐 Access token stored securely");
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token;
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
