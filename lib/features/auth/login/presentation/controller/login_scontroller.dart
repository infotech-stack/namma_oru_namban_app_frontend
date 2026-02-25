import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class LoginController extends GetxController {
  final mobileController = TextEditingController();
  final isLoading = false.obs;

  void onLogin() {
    final mobile = mobileController.text.trim();

    // if (mobile.isEmpty) {
    //   AppSnackbar.error("enter_register_number");
    //   return;
    // }

    // TODO: API call to send OTP
    Get.offAllNamed(Routes.wrapper, arguments: {'mobile': mobile});
    AppSnackbar.success("login_success");
  }

  void onCreateAccount() {
    Get.toNamed(Routes.signUpScreen);
  }

  @override
  void onClose() {
    mobileController.dispose();
    super.onClose();
  }
}
