// lib/features/profile/presentation/controller/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/storage/hive_service.dart';
import 'package:userapp/features/profile/presentation/widget/profile_model_widget.dart';
import 'package:userapp/utils/constants/app_images.dart';

class ProfileController extends GetxController {
  final HiveService _hive = HiveService();

  final profile = Rx<ProfileModel>(
    ProfileModel(
      name: 'John Smith',
      memberSince: '2023',
      imagePath: AppAssetsConstants.profile,
    ),
  );

  void toggleLorryTrucks(bool value) {
    profile.value = profile.value.copyWith(lorryTrucksEnabled: value);
  }

  void toggleJcbExcavators(bool value) {
    profile.value = profile.value.copyWith(jcbExcavatorsEnabled: value);
  }

  void toggleCarTataAce(bool value) {
    profile.value = profile.value.copyWith(carTataAceEnabled: value);
  }

  void onEditProfile() {
    // TODO: Navigate to Edit Profile screen
  }

  void onPaymentMethods() {
    // TODO: Navigate to Payment Methods screen
  }

  void onNotificationSettings() {
    // TODO: Navigate to Notification Settings screen
  }

  void onSavedAddresses() {
    // TODO: Navigate to Saved Addresses screen
  }

  Future<void> onLogOut() async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // ✅ CALL HIVE LOGOUT
      await _hive.logout(); // Use this if you added the better logout method
      // OR
      // await _hive.clearUserDetails();  // Use this for simple clear
      // await _hive.setLoggedIn(false);  // Also set login status

      // Close loading dialog
      if (Get.isDialogOpen ?? false) Get.back();

      AppLogger.info('✅ Logout successful');

      // Navigate to login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.loginScreen);
      });
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) Get.back();

      AppLogger.error('❌ Logout error: $e');
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
