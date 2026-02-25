import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';

class AppConfirmDialog {
  static void show({
    required ThemeData theme,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = "confirm",
    String cancelText = "cancel",
    Color? confirmColor,
    IconData icon = Icons.warning_rounded,
    Color? iconColor,
    bool isLocalized = true,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        backgroundColor: theme.colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔥 Top Icon Circle
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (iconColor ?? confirmColor ?? theme.colorScheme.primary)
                          .withValues(alpha: 0.1),
                ),
                child: Icon(
                  icon,
                  size: 30.sp,
                  color: iconColor ?? confirmColor ?? theme.colorScheme.primary,
                ),
              ),

              SizedBox(height: 18.h),

              /// Title
              Text(
                isLocalized ? title.tr : title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: responsiveFont(en: 16.sp, ta: 12.sp),
                  color: theme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 10.h),

              /// Message
              Text(
                isLocalized ? message.tr : message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                  color: theme.dividerColor,
                ),
              ),

              SizedBox(height: 24.h),

              /// Buttons
              Row(
                children: [
                  /// Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: theme.colorScheme.outline, // ✅ correct border
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      onPressed: Get.back,
                      child: Text(
                        isLocalized ? cancelText.tr : cancelText,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  /// Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            confirmColor ?? theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        onConfirm();
                      },
                      child: Text(
                        isLocalized ? confirmText.tr : confirmText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondary,
                          fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
