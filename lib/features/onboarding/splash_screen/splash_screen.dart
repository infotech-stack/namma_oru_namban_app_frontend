// lib/features/splash/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/storage/hive_service.dart';
import 'package:userapp/utils/constants/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _scaleAnimation;

  final HiveService _hive = HiveService();
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _positionAnimation = Tween<double>(
      begin: 300,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _navigationTimer = Timer(const Duration(seconds: 3), _checkLoginStatus);
  }

  /// Flow:
  ///   isLoggedIn = false → Login screen
  ///   isLoggedIn = true  → Home (wrapper)
  ///
  /// Note: isNewUser check வேண்டாம் —
  ///   register/send-otp → verify-otp success → user created → isLoggedIn = true → home
  ///   login/send-otp    → verify-otp success → isLoggedIn = true → home
  Future<void> _checkLoginStatus() async {
    try {
      final isLoggedIn = _hive.isLoggedIn();
      AppLogger.info('🔍 Splash — isLoggedIn: $isLoggedIn');

      if (isLoggedIn) {
        final name = _hive.getUserName();
        AppLogger.info('👋 Logged in user: $name → Home');
        Get.offAllNamed(Routes.wrapper, arguments: 0);
      } else {
        AppLogger.info('🔒 Not logged in → Login screen');
        Get.offAllNamed(Routes.loginScreen);
      }
    } catch (e) {
      AppLogger.error('❌ Splash error: $e');
      Get.offAllNamed(Routes.loginScreen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F9FF), Color(0xFFEDE7FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _positionAnimation.value),
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: SvgPicture.asset(
                        AppAssetsConstants.appLogo2,
                        width: 150.w,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 60.h),
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                child: GradientText(
                  "UNGA OORU",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 6,
                    fontFamily: "PlayfairDisplay",
                  ),
                  colors: const [Color(0xFF6A00FF), Color(0xFF9D4EDD)],
                ),
              ),
              SizedBox(height: 12.h),
              BounceInDown(
                delay: const Duration(milliseconds: 1500),
                child: GradientText(
                  "NANBAN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    fontFamily: "PlayfairDisplay",
                  ),
                  colors: const [
                    Color(0xFF4B0082),
                    Color(0xFF7B2CBF),
                    Color(0xFF9D4EDD),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              FadeIn(
                delay: const Duration(milliseconds: 2200),
                child: Text(
                  "Your Trusted Local Ride Partner",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
