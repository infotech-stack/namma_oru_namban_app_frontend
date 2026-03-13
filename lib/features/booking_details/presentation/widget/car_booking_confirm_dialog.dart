// lib/features/booking/car/widgets/car_booking_confirm_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

void showCarBookingConfirmedDialog({
  required String bookingId,
  required VoidCallback onViewBooking,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: Get.context?.theme.colorScheme.secondary,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.r,
              height: 60.r,
              decoration: BoxDecoration(
                color: AppTheme.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppTheme.green,
                size: 40.sp,
              ),
            ),
            Gap(16.h),
            BText(
              text: 'booking_confirmed',
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              isLocalized: true,
            ),
            Gap(8.h),
            BText(
              text: 'booking_id',
              textAfter: bookingId,
              fontSize: 14.sp,
              color: Get.context?.theme.dividerColor,
              isLocalized: true,
            ),
            Gap(16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Get.context?.theme.dividerColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16.sp,
                    color: Get.context?.theme.colorScheme.primary,
                  ),
                  Gap(8.w),
                  Expanded(
                    child: BText(
                      text: 'booking_success_message',
                      fontSize: 12.sp,
                      color: Get.context?.theme.colorScheme.onSurface,
                      isLocalized: true,
                    ),
                  ),
                ],
              ),
            ),
            Gap(20.h),
            Column(
              children: [
                BButton(
                  text: 'view_booking',
                  onTap: onViewBooking,
                  isOutline: true,
                ),
                Gap(12.w),
                BButton(text: 'close', onTap: () => Get.back()),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
