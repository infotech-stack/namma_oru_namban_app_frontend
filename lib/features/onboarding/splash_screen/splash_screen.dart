import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:userapp/core/route/app_routes.dart';

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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.forward();

    // Navigate after animation
    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.signUpScreen);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Bottom to Top animation
    _positionAnimation = Tween<double>(
      begin: screenHeight, // Start from bottom
      end: screenHeight * 0.25, // Stop near top
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Small to Big scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.3, // Small
      end: 1.5, // Big
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // App Name
          Center(
            child: Text(
              "Vehicle Booking",
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
            ),
          ),

          // 🚗 Animated Car
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: _positionAnimation.value,
                left: MediaQuery.of(context).size.width / 2 - 50.w,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    Icons.directions_car,
                    size: 100.w,
                    color: Colors.blue,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
