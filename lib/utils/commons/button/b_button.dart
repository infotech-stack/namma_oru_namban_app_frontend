import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';

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
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  final double? fontSize;
  final FontWeight? fontWeight;

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
    this.fontSize,
    this.fontWeight,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
        onTap: isLoading ? null : onTap,
        child: Container(
          height: height ?? 45.h,
          width: width ?? double.infinity,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w),
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
                      color: primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),

          /// 🔥 CONTENT
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max, // ✅ important
                    children: [
                      if (prefixIcon != null) ...[
                        prefixIcon!,
                        SizedBox(width: 4.w),
                      ],

                      /// ✅ TEXT (NO FLEXIBLE)
                      Text(
                        isLocalized ? text.tr : text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              textColor ?? (isOutline ? primary : Colors.white),
                          fontSize: fontSize ?? 13.sp, // 👈 slightly reduce
                          fontWeight: fontWeight ?? FontWeight.w600,
                        ),
                      ),

                      if (suffixIcon != null) ...[
                        SizedBox(width: 4.w),
                        suffixIcon!,
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
