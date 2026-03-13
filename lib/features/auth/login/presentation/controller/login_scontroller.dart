// lib/features/auth/login/controller/login_controller.dart
// ════════════════════════════════════════════════════════════════
//  LOGIN CONTROLLER
//  POST /user/auth/send-otp
//  → success          : navigate to OTP screen
//  → NOT_REGISTERED   : navigate to SignUp screen
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:userapp/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class LoginController extends GetxController {
  late final SendOtpUseCase _sendOtpUseCase;

  LoginController() {
    _sendOtpUseCase = SendOtpUseCase(AuthRepositoryImpl());
  }

  final mobileController = TextEditingController();
  final isLoading = false.obs;

  void onLogin() async {
    final mobile = mobileController.text.trim();

    if (mobile.isEmpty) {
      AppSnackbar.error('Please enter mobile number');
      return;
    }
    if (mobile.length < 10) {
      AppSnackbar.error('Please enter valid 10-digit mobile number');
      return;
    }

    isLoading.value = true;

    final result = await _sendOtpUseCase(mobile);

    isLoading.value = false;

    if (result.isSuccess) {
      // ✅ Registered user → OTP screen
      AppSnackbar.success('OTP sent successfully');
      Get.toNamed(
        Routes.otpScreen,
        arguments: {'mobile': mobile, 'flow': 'login'},
      );
    } else if (result.code == 'NOT_REGISTERED') {
      // ❌ Not registered → SignUp screen with mobile pre-filled
      AppSnackbar.warning('Number not registered. Please sign up!');
      Get.toNamed(Routes.signUpScreen, arguments: {'mobile': mobile});
    } else {
      AppSnackbar.error(result.error ?? 'Something went wrong.');
    }
  }

  void onCreateAccount() => Get.toNamed(Routes.signUpScreen);

  @override
  void onClose() {
    mobileController.dispose();
    super.onClose();
  }
}
