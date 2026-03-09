import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';

class BGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  final bool isLocalized;
  final bool isLoading;
  final bool isLightGlass; // 🔥 NEW

  final Gradient? gradient;
  final Color? textColor;
  final Color? borderColor;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  final double? fontSize;
  final FontWeight? fontWeight;

  const BGlassButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLocalized = true,
    this.isLoading = false,
    this.isLightGlass = false, // default dark glass
    this.gradient,
    this.textColor,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.height,
    this.borderRadius,
    this.padding,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.colorScheme.primary;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: height ?? 45.h,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null
                  ? (isLightGlass
                        ? Colors.white.withValues(alpha: 0.55)
                        : Colors.white.withValues(alpha: 0.18))
                  : null,
              borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
              border: Border.all(
                color:
                    borderColor ??
                    (isLightGlass
                        ? Colors.grey.withValues(alpha: 0.35)
                        : Colors.white.withValues(alpha: 0.35)),
              ),
              boxShadow: [
                BoxShadow(
                  color: isLightGlass
                      ? Colors.black.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isLightGlass ? primary : Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (prefixIcon != null) ...[
                          prefixIcon!,
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          isLocalized ? text.tr : text,
                          style: TextStyle(
                            color:
                                textColor ??
                                (isLightGlass ? primary : Colors.white),
                            fontSize:
                                fontSize ?? responsiveFont(en: 16, ta: 14),
                            fontWeight: fontWeight ?? FontWeight.w600,
                          ),
                        ),
                        if (suffixIcon != null) ...[
                          SizedBox(width: 8.w),
                          suffixIcon!,
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class BNumericButton extends StatelessWidget {
  final String number;
  final String? letters;
  final VoidCallback onTap;

  const BNumericButton({
    super.key,
    required this.number,
    required this.onTap,
    this.letters,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onTap,
      child: Ink(
        height: 70.h,
        width: 70.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, primary.withValues(alpha: 0.75)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.35),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (letters != null)
              Text(
                letters!,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
