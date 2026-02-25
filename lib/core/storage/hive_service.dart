import 'package:hive_flutter/hive_flutter.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/utils/constants/storage_keys.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(StorageKeys.settingsBox);
    AppLogger.info("✅ Hive initialized");
  }

  // ---------------- LANGUAGE ----------------

  Future<void> saveLanguage(String code) async {
    await _settingsBox.put(StorageKeys.languageCode, code);
    AppLogger.info("🌍 Language saved: $code");
  }

  String getLanguage() {
    final code = _settingsBox.get(StorageKeys.languageCode, defaultValue: "en");
    AppLogger.info("📦 Language fetched: $code");
    return code;
  }
}
