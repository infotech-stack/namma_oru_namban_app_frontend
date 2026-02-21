import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  final bool isLocalized;
  final bool isLoading;
  final bool isOutline;

  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const BButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLocalized = true,
    this.isLoading = false,
    this.isOutline = false,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.height,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.colorScheme.primary;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height ?? 56.h,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: isOutline
              ? null
              : gradient ??
                    LinearGradient(
                      colors: [primary, primary.withValues(alpha: 0.8)],
                    ),
          color: isOutline ? Colors.transparent : backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
          border: isOutline
              ? Border.all(color: borderColor ?? primary, width: 1.5)
              : null,
          boxShadow: isOutline
              ? []
              : [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
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
                            textColor ?? (isOutline ? primary : Colors.white),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
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
    );
  }
}
