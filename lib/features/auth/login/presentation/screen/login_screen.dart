import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/features/auth/login/presentation/controller/login_scontroller.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/utils/commons/textfield/b_textfiled.dart';
import 'package:userapp/utils/constants/app_images.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

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

  Widget _buildFormSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BText(
          text: 'welcome_back',
          fontSize: responsiveFont(en: 18.sp, ta: 16.sp),
          fontWeight: FontWeight.w700,
          isLocalized: true,
        ),
        SizedBox(height: 8.h),
        BText(
          text: 'login_subtitle',
          fontSize: 12.sp,
          color: theme.dividerColor,
          textAlign: TextAlign.center,
          isLocalized: true,
        ),
        SizedBox(height: 28.h),

        // Mobile Number Field
        BTextField(
          controller: controller.mobileController,
          hintText: "9988776655",
          isLocalized: true,
          keyboardType: TextInputType.phone,
          labelText: "enter_registered_mobile",
        ),
        SizedBox(height: 28.h),

        _buildLoginButton(theme),
        SizedBox(height: 20.h),

        _buildCreateAccountRow(theme),
        SizedBox(height: 16.h),
      ],
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

  Widget _buildCreateAccountRow(ThemeData theme) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BText(
            text: 'no_account',
            fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
            color: theme.dividerColor,
            isLocalized: true,
          ),
          GestureDetector(
            onTap: controller.onCreateAccount,
            child: BText(
              text: 'create_account_link',
              fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
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
