// lib/features/auth/otp/presentation/controller/otp_controller.dart
// ════════════════════════════════════════════════════════════════
//  OTP CONTROLLER — handles both login + register verify
//  flow: 'login' | 'register'  (from arguments)
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/storage/hive_service.dart';
import 'package:userapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:userapp/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class OtpController extends GetxController {
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final SendOtpUseCase _sendOtpUseCase;
  late final RegisterSendOtpUseCase _registerSendOtpUseCase;
  final HiveService _hive = HiveService();

  OtpController() {
    final repo = AuthRepositoryImpl();
    _verifyOtpUseCase = VerifyOtpUseCase(repo);
    _sendOtpUseCase = SendOtpUseCase(repo);
    _registerSendOtpUseCase = RegisterSendOtpUseCase(repo);
  }

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final mobileNumber = ''.obs;
  final name = ''.obs;
  final flow = 'login'.obs; // 'login' | 'register'
  final isLoading = false.obs;
  final isResending = false.obs;
  final resendSeconds = 60.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      mobileNumber.value = args['mobile'] as String? ?? '';
      name.value = args['name'] as String? ?? '';
      flow.value = args['flow'] as String? ?? 'login';
    }
    _startResendTimer();
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
        onVerify();
      }
    } else {
      if (index > 0) focusNodes[index - 1].requestFocus();
    }
  }

  void onVerify() async {
    final otp = otpControllers.map((c) => c.text.trim()).join();

    if (otp.length != 6) {
      AppSnackbar.error('Please enter complete OTP');
      return;
    }

    isLoading.value = true;

    final result = await _verifyOtpUseCase(
      mobile: mobileNumber.value,
      otp: otp,
    );

    isLoading.value = false;

    if (result.isSuccess && result.data != null) {
      final verifyData = result.data!;

      // Save user to Hive
      await _hive.saveUserFromEntity(verifyData);

      AppLogger.info(
        '✅ OTP verified | type: ${verifyData.type} | isNewUser: ${verifyData.isNewUser}',
      );

      if (verifyData.type == 'register') {
        // ✅ Register success → home
        AppSnackbar.success(
          'Welcome ${verifyData.user.name ?? ""}! Registration successful.',
        );
        Get.offAllNamed(Routes.wrapper);
      } else {
        // ✅ Login success → home
        await HiveService().init();
        AppSnackbar.success('Welcome back!');
        Get.offAllNamed(Routes.wrapper);
      }
    } else {
      AppSnackbar.error(result.error ?? 'Invalid OTP. Please try again.');
      _clearBoxes();
    }
  }

  // Resend — use correct endpoint based on flow
  void onResend() async {
    if (resendSeconds.value > 0) return;

    isResending.value = true;

    if (flow.value == 'register') {
      // Register flow → register/send-otp
      final result = await _registerSendOtpUseCase(
        mobile: mobileNumber.value,
        name: name.value.isEmpty ? null : name.value,
      );
      isResending.value = false;
      if (result.isSuccess) {
        AppSnackbar.success('OTP resent successfully!');
        _clearBoxes();
        _startResendTimer();
      } else {
        AppSnackbar.error(result.error ?? 'Failed to resend OTP.');
      }
    } else {
      // Login flow → send-otp
      final result = await _sendOtpUseCase(mobileNumber.value);
      isResending.value = false;
      if (result.isSuccess) {
        AppSnackbar.success('OTP resent successfully!');
        _clearBoxes();
        _startResendTimer();
      } else {
        AppSnackbar.error(result.error ?? 'Failed to resend OTP.');
      }
    }
  }

  void onEditMobile() => Get.back();

  void _startResendTimer() {
    resendSeconds.value = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
        return true;
      }
      return false;
    });
  }

  void _clearBoxes() {
    for (final c in otpControllers) c.clear();
    if (focusNodes.isNotEmpty) focusNodes[0].requestFocus();
  }

  @override
  void onClose() {
    for (final c in otpControllers) c.dispose();
    for (final f in focusNodes) f.dispose();
    super.onClose();
  }
}
