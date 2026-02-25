import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';

double responsiveFont({required double en, required double ta}) {
  // Safe controller access
  if (Get.isRegistered<LanguageController>()) {
    final controller = Get.find<LanguageController>();
    final code = controller.currentLocale.value.languageCode;

    return code == 'en' ? en.sp : ta.sp;
  }

  // Fallback if controller not ready
  final localeCode = Get.locale?.languageCode ?? 'en';
  return localeCode == 'en' ? en.sp : ta.sp;
}
