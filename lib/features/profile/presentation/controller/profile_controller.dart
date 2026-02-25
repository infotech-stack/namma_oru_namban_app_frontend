// lib/features/profile/presentation/controller/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/profile/presentation/widget/profile_model_widget.dart';
import 'package:userapp/utils/constants/app_images.dart';

class ProfileController extends GetxController {
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

  void onLogOut() {
    // Small delay lets the current gesture/frame resolve before navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(Routes.loginScreen);
    });
  }
}
