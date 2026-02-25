import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:userapp/core/storage/hive_service.dart';

class LanguageController extends GetxController {
  final HiveService _hive = HiveService();

  var currentLocale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();

    // 🔥 Load saved language from Hive
    final savedCode = _hive.getLanguage();
    currentLocale.value = Locale(savedCode);

    Get.updateLocale(currentLocale.value);
  }

  void toggleLanguage() async {
    final newCode = currentLocale.value.languageCode == 'en' ? 'ta' : 'en';

    currentLocale.value = Locale(newCode);
    Get.updateLocale(currentLocale.value);

    // 🔥 Save to Hive
    await _hive.saveLanguage(newCode);
  }
}
