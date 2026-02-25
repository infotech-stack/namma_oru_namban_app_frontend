import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/features/auth/signup/controller/signup_controller.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/utils/constants/app_images.dart';
import '../controller/otp_controller.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.find<SignUpController>();
    final primaryColor = Get.theme.colorScheme.primary;
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Gap(10.h),
                  _buildHeader(theme),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.secondary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(35.r),
                          topLeft: Radius.circular(35.r),
                        ),
                      ),
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                        top: 28.h,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                      ),
                      child: _buildFormSection(theme, signUpController),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      color: Get.theme.colorScheme.primary,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20.h),
          SizedBox(
            height: 250.h,
            child: Image.asset(AppAssetsConstants.loginTopImage),
          ),
          Text(
            'book_heavy_vehicles'.tr,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: responsiveFont(en: 22.sp, ta: 18.sp),
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.3,
              fontFamily: "PlayfairDisplay",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(ThemeData theme, SignUpController signUpController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          text: 'confirm_number',
          fontSize: responsiveFont(en: 18.sp, ta: 15.sp),
          fontWeight: FontWeight.w700,
          isLocalized: true,
        ),
        SizedBox(height: 6.h),
        Obx(
          () => BText(
            text:
                '${'enter_code_sent'.tr}${signUpController.mobileNumber.value}',
            fontSize: 12.sp,
            color: theme.dividerColor,
            isLocalized: false,
          ),
        ),
        SizedBox(height: 10.h),
        _buildEditMobileRow(theme),
        SizedBox(height: 28.h),
        _buildOtpFields(theme),
        SizedBox(height: 16.h),
        _buildResendRow(theme),
        SizedBox(height: 28.h),
        _buildLoginButton(theme),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildEditMobileRow(ThemeData theme) {
    return GestureDetector(
      onTap: controller.onEditMobile,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, size: 14.sp, color: Get.theme.colorScheme.primary),
          SizedBox(width: 4.w),
          BText(
            text: 'edit_mobile',
            fontSize: 12.sp,
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
            isLocalized: true,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpFields(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) => _buildOtpBox(index, theme)),
    );
  }

  Widget _buildOtpBox(int index, ThemeData theme) {
    return SizedBox(
      width: 44.w,
      height: 52.h,
      child: TextFormField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: Get.theme.colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
        ),
        onChanged: (value) => controller.onOtpChanged(value, index),
      ),
    );
  }

  Widget _buildResendRow(ThemeData theme) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BText(
            text: 'dont_get_sms',
            fontSize: 12.sp,
            color: theme.dividerColor,
            isLocalized: true,
          ),
          GestureDetector(
            onTap: controller.onResend,
            child: BText(
              text: 'send_again',
              fontSize: 12.sp,
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              isLocalized: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return BButton(
      text: "login_btn",
      isLocalized: true,
      //textColor: theme.secondaryHeaderColor,
      onTap: controller.onLogin,
      suffixIcon: Icon(Icons.arrow_forward, color: theme.colorScheme.secondary),
    );
  }
}
