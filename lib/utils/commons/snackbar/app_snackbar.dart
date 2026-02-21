import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSnackbar {
  static void success(String messageKey, {String titleKey = "success"}) {
    _showSnackbar(
      titleKey.tr,
      messageKey.tr,
      Colors.green,
      Icons.check_circle,
      const Duration(seconds: 2),
    );
  }

  static void error(String messageKey, {String titleKey = "error"}) {
    _showSnackbar(
      titleKey.tr,
      messageKey.tr,
      Colors.red,
      Icons.error,
      const Duration(seconds: 3),
    );
  }

  static void warning(String messageKey, {String titleKey = "warning"}) {
    _showSnackbar(
      titleKey.tr,
      messageKey.tr,
      Colors.orange,
      Icons.warning,
      const Duration(seconds: 2),
    );
  }

  static void _showSnackbar(
    String title,
    String message,
    Color bgColor,
    IconData icon,
    Duration duration,
  ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgColor,
      colorText: Colors.white,
      margin: EdgeInsets.all(12.w),
      borderRadius: 10.r,
      duration: duration,
      icon: Icon(icon, color: Colors.white),
    );
  }
}
