import 'package:hive_flutter/hive_flutter.dart';

class ApiCacheService {
  static const _boxName = "api_cache";

  Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  Future<void> save(String key, dynamic data) async {
    final box = await _openBox();
    await box.put(key, data);
  }

  Future<dynamic> get(String key) async {
    final box = await _openBox();
    return box.get(key);
  }
}
