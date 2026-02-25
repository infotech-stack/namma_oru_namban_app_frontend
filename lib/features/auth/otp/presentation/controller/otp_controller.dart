import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final mobileNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Receive mobile number passed via Get.toNamed arguments
    final args = Get.arguments;
    if (args != null && args['mobile'] != null) {
      mobileNumber.value = args['mobile'];
    }
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  void onEditMobile() {
    Get.back();
  }

  void onResend() {
    // TODO: Resend OTP API call
    /*  Get.snackbar(
      'OTP',
      'Code resent successfully',
      snackPosition: SnackPosition.BOTTOM,
    );*/
    AppSnackbar.success('Code resent successfully');
  }

  void onLogin() {
    final otp = otpControllers.map((c) => c.text.trim()).join();
    if (otp.length < 6) {
      AppSnackbar.error('fill_fields'.tr);
      return;
    }
    // TODO: Verify OTP API call
    Get.toNamed(Routes.loginScreen);
  }

  @override
  void onClose() {
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
