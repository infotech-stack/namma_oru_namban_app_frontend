import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSnackbar {
  /// ✅ SUCCESS
  static void success(String message, {String? title, bool isRaw = false}) {
    _showSnackbar(
      isRaw ? (title ?? "Success") : (title ?? "success").tr,
      isRaw ? message : message.tr,
      Colors.green,
      Icons.check_circle,
      const Duration(seconds: 2),
    );
  }

  /// ❌ ERROR
  static void error(String message, {String? title, bool isRaw = false}) {
    _showSnackbar(
      isRaw ? (title ?? "Error") : (title ?? "error").tr,
      isRaw ? message : message.tr,
      Colors.red,
      Icons.error,
      const Duration(seconds: 3),
    );
  }

  /// ⚠️ WARNING
  static void warning(String message, {String? title, bool isRaw = false}) {
    _showSnackbar(
      isRaw ? (title ?? "Warning") : (title ?? "warning").tr,
      isRaw ? message : message.tr,
      Colors.orange,
      Icons.warning,
      const Duration(seconds: 2),
    );
  }

  /// 🔥 CORE SNACKBAR METHOD
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
