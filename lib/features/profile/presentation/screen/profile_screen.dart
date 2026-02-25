// lib/features/profile/presentation/screen/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/profile/presentation/controller/profile_controller.dart';
import 'package:userapp/features/profile/presentation/widget/profile_model_widget.dart';
import 'package:userapp/utils/commons/app_dialogs/app_confirm_dialog_widget.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.find<LanguageController>();
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Column(
          children: [
            _buildHeader(theme, langController),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Obx(() {
                  final p = controller.profile.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(20.h),
                      _buildMenuCard(theme, p),
                      Gap(24.h),
                      _buildVehiclePreferences(theme, p),
                      Gap(30.h),
                      _buildLogOutButton(theme),
                      Gap(30.h),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Purple Header with Avatar ──────────────────────────────────────────────

  Widget _buildHeader(ThemeData theme, LanguageController langController) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8), // 👈 down shadow
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.h,
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
          ),
          child: Column(
            children: [
              // Top Row: Back + Language
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        langController.currentLocale.value.languageCode == 'en'
                            ? Icons.language
                            : Icons.translate,
                        color: theme.colorScheme.secondary,
                      ),
                      onPressed: () => langController.toggleLanguage(),
                    ),
                  ),
                ],
              ),
              Gap(10.h),

              // Avatar
              Obx(() {
                final p = Get.find<ProfileController>().profile.value;
                return Stack(
                  children: [
                    Container(
                      width: 75.w,
                      height: 75.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.secondary,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: p.imagePath != null
                            ? Image.asset(p.imagePath!, fit: BoxFit.cover)
                            : Container(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 48.sp,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 12.sp,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                );
              }),

              Gap(5.h),

              // Name
              Obx(() {
                final p = Get.find<ProfileController>().profile.value;
                return Column(
                  children: [
                    BText(
                      text: p.name,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.secondary,
                      isLocalized: false,
                    ),
                    //Gap(4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BText(
                          text: 'member_since',
                          fontSize: 12.sp,
                          color: theme.colorScheme.secondary.withValues(
                            alpha: 0.8,
                          ),
                          isLocalized: true,
                        ),
                        BText(
                          text: ' ${p.memberSince}',
                          fontSize: 12.sp,
                          color: theme.colorScheme.secondary.withValues(
                            alpha: 0.8,
                          ),
                          isLocalized: false,
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── Menu Options Card ──────────────────────────────────────────────────────

  Widget _buildMenuCard(ThemeData theme, ProfileModel p) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildMenuItem(
              theme: theme,
              icon: Icons.person_outline_rounded,
              labelKey: 'edit_profile',
              onTap: controller.onEditProfile,
              isFirst: true,
            ),
            _buildDivider(theme),
            _buildMenuItem(
              theme: theme,
              icon: Icons.credit_card_rounded,
              labelKey: 'payment_methods',
              onTap: controller.onPaymentMethods,
            ),
            _buildDivider(theme),
            _buildMenuItem(
              theme: theme,
              icon: Icons.notifications_none_rounded,
              labelKey: 'notification_settings',
              onTap: controller.onNotificationSettings,
            ),
            _buildDivider(theme),
            _buildMenuItem(
              theme: theme,
              icon: Icons.location_on_outlined,
              labelKey: 'saved_addresses',
              onTap: controller.onSavedAddresses,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required ThemeData theme,
    required IconData icon,
    required String labelKey,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? Radius.circular(16.r) : Radius.zero,
            topRight: isFirst ? Radius.circular(16.r) : Radius.zero,
            bottomLeft: isLast ? Radius.circular(16.r) : Radius.zero,
            bottomRight: isLast ? Radius.circular(16.r) : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20.sp),
            ),
            Gap(14.w),
            Expanded(
              child: BText(
                text: labelKey,
                fontSize: responsiveFont(en: 13.sp, ta: 12.sp),
                fontWeight: FontWeight.w500,
                // color: theme.colorScheme.onSurface,
                isLocalized: true,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.dividerColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        color: theme.dividerColor.withValues(alpha: 0.15),
        height: 1,
      ),
    );
  }

  // ── Vehicle Preferences ────────────────────────────────────────────────────

  Widget _buildVehiclePreferences(ThemeData theme, ProfileModel p) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BText(
            text: 'vehicle_preferences',
            fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            isLocalized: true,
          ),
          Gap(12.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildToggleRow(
                  theme: theme,
                  icon: Icons.local_shipping_rounded,
                  iconColor: theme.colorScheme.primary,
                  labelKey: 'lorry_trucks',
                  value: p.lorryTrucksEnabled,
                  onChanged: controller.toggleLorryTrucks,
                  isFirst: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                    height: 1,
                  ),
                ),
                _buildToggleRow(
                  theme: theme,
                  icon: Icons.construction_rounded,
                  iconColor: AppTheme.greyMedium,
                  labelKey: 'jcb_excavators',
                  value: p.jcbExcavatorsEnabled,
                  onChanged: controller.toggleJcbExcavators,
                  isLast: false,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                    height: 1,
                  ),
                ),
                _buildToggleRow(
                  theme: theme,
                  icon: Icons.directions_car_filled,
                  iconColor: theme.colorScheme.primary,
                  labelKey: 'car_tatacce',
                  value: p.carTataAceEnabled,
                  onChanged: controller.toggleCarTataAce,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String labelKey,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? Radius.circular(16.r) : Radius.zero,
          topRight: isFirst ? Radius.circular(16.r) : Radius.zero,
          bottomLeft: isLast ? Radius.circular(16.r) : Radius.zero,
          bottomRight: isLast ? Radius.circular(16.r) : Radius.zero,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          Gap(14.w),
          Expanded(
            child: BText(
              text: labelKey,
              fontSize: responsiveFont(en: 13.sp, ta: 12.sp),
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
              isLocalized: true,
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: theme.colorScheme.primary,
            activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  // ── Log Out Button ─────────────────────────────────────────────────────────

  Widget _buildLogOutButton(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () => AppConfirmDialog.show(
          theme: theme,
          title: "log_out",
          message: "logout_confirm",
          confirmColor: AppTheme.red,
          icon: Icons.logout_rounded,
          iconColor: AppTheme.red,
          onConfirm: controller.onLogOut,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: AppTheme.red.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppTheme.red.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: AppTheme.red, size: 18.sp),
              Gap(8.w),
              BText(
                text: 'log_out',
                fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
                fontWeight: FontWeight.w600,
                color: AppTheme.red,
                isLocalized: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
