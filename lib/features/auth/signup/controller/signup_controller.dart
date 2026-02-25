import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';

class SignUpController extends GetxController {
  // Text Controllers
  final usernameController = TextEditingController();
  final mobileController = TextEditingController();

  // Reactive Variables
  final isLoading = false.obs;
  final mobileNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen mobile field changes
    mobileController.addListener(() {
      mobileNumber.value = mobileController.text.trim();
    });
  }

  void onGetCode() async {
    final username = usernameController.text.trim();
    final mobile = mobileNumber.value;

    if (username.isEmpty || mobile.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2)); // Fake API

    isLoading.value = false;

    // Navigate to OTP with argument
    Get.toNamed(Routes.otpScreen, arguments: mobile);
  }

  void onLogin() {
    Get.toNamed(Routes.loginScreen);
  }

  @override
  void onClose() {
    usernameController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
