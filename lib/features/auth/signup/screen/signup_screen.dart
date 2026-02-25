import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/auth/signup/controller/signup_controller.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/utils/commons/textfield/b_textfiled.dart';
import 'package:userapp/utils/constants/app_images.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      child: _buildFormSection(theme),
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
    final isEnglish = (Get.locale?.languageCode ?? 'en') == 'en';
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
          //SizedBox(height: 10.h),
          Text(
            'book_heavy_vehicles'.tr,
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: isEnglish ? 22.sp : 18.sp,
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

  Widget _buildFormSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          text: 'create_account',
          fontSize: (Get.locale?.languageCode ?? 'en') == 'en' ? 18.sp : 16.sp,
          fontWeight: FontWeight.w700,
          isLocalized: true,
        ),
        SizedBox(height: 6.h),
        BText(
          text: 'enter_mobile',
          fontSize: 12.sp,
          color: theme.dividerColor,
          isLocalized: true,
        ),
        SizedBox(height: 28.h),

        // Username
        BTextField(
          controller: controller.usernameController,
          hintText: "hint_name",
          isLocalized: true,
          labelText: "username",
        ),
        SizedBox(height: 14.h),

        // Mobile
        BTextField(
          controller: controller.mobileController,
          hintText: "9988776655",
          isLocalized: true,
          keyboardType: TextInputType.phone,
          labelText: "mobile_number",
        ),
        SizedBox(height: 28.h),

        _buildGetCodeButton(theme),
        SizedBox(height: 20.h),

        _buildLoginRow(theme),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildGetCodeButton(ThemeData theme) {
    return BButton(
      text: "get_code",
      isLocalized: true,
      // textColor: theme.secondaryHeaderColor,
      onTap: () {
        Get.toNamed(Routes.otpScreen);
      },
      suffixIcon: Icon(Icons.arrow_forward, color: theme.colorScheme.secondary),
    );
  }

  Widget _buildLoginRow(ThemeData theme) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BText(
            text: 'already_account',
            fontSize: responsiveFont(en: 12, ta: 10),
            color: theme.dividerColor,
            isLocalized: true,
          ),
          GestureDetector(
            onTap: controller.onLogin,
            child: BText(
              text: 'login',
              fontSize: Get.locale?.languageCode == 'en' ? 12.sp : 10.sp,
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              isLocalized: true,
            ),
          ),
        ],
      ),
    );
  }
}
