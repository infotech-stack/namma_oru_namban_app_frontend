// lib/features/auth/signup/controller/signup_controller.dart
// ════════════════════════════════════════════════════════════════
//  SIGNUP CONTROLLER
//  POST /user/auth/register/send-otp
//  → success            : navigate to OTP screen
//  → ALREADY_REGISTERED : navigate to Login screen
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:userapp/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class SignUpController extends GetxController {
  late final RegisterSendOtpUseCase _registerSendOtpUseCase;

  SignUpController() {
    _registerSendOtpUseCase = RegisterSendOtpUseCase(AuthRepositoryImpl());
  }

  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-fill mobile if coming from Login screen (NOT_REGISTERED flow)
    final args = Get.arguments;
    if (args != null && args['mobile'] != null) {
      mobileController.text = args['mobile'] as String;
    }
  }

  void onRegister() async {
    final mobile = mobileController.text.trim();
    final name = nameController.text.trim();

    // Validation
    if (mobile.isEmpty || mobile.length < 10) {
      AppSnackbar.error('Please enter valid 10-digit mobile number');
      return;
    }
    // name optional — but if entered, min 2 chars
    if (name.isNotEmpty && name.length < 2) {
      AppSnackbar.error('Name must be at least 2 characters');
      return;
    }

    isLoading.value = true;

    final result = await _registerSendOtpUseCase(
      mobile: mobile,
      name: name.isEmpty ? null : name,
    );

    isLoading.value = false;

    if (result.isSuccess) {
      // ✅ New user → OTP screen
      AppSnackbar.success('OTP sent successfully');
      Get.toNamed(
        Routes.otpScreen,
        arguments: {
          'mobile': mobile,
          'name': name,
          'flow': 'register', // OTP controller la flow check pannuvom
        },
      );
    } else if (result.code == 'ALREADY_REGISTERED') {
      // ❌ Already registered → Login screen
      AppSnackbar.warning('Already registered! Please login.');
      Get.toNamed(Routes.loginScreen, arguments: {'mobile': mobile});
    } else {
      AppSnackbar.error(result.error ?? 'Something went wrong.');
    }
  }

  void onLogin() => Get.toNamed(Routes.loginScreen);

  @override
  void onClose() {
    mobileController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
