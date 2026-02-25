// lib/features/booking_details/presentation/widget/booking_confirmed_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class BookingConfirmedDialog extends StatelessWidget {
  final String bookingId;
  final VoidCallback onViewBooking;

  const BookingConfirmedDialog({
    super.key,
    required this.bookingId,
    required this.onViewBooking,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 28.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Animated Check Circle ─────────────────────────────────
            _buildCheckCircle(theme),
            Gap(20.h),

            // ── Title ─────────────────────────────────────────────────
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'booking_confirmed'.tr,
                    style: TextStyle(
                      fontSize: responsiveFont(en: 20.sp, ta: 16.sp),
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const TextSpan(text: ' 🎉'),
                ],
              ),
            ),
            Gap(8.h),

            // ── Subtitle ──────────────────────────────────────────────
            BText(
              text: 'vehicle_on_way',
              fontSize: 12.sp,
              color: theme.dividerColor,
              isLocalized: true,
            ),
            Gap(20.h),

            // ── Booking ID Badge ──────────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BText(
                    text: 'booking_id_label',
                    fontSize: 12.sp,
                    color: theme.colorScheme.onSurface,
                    isLocalized: true,
                  ),
                  BText(
                    text: ' $bookingId',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    isLocalized: false,
                  ),
                ],
              ),
            ),
            Gap(24.h),

            // ── View Booking Button ───────────────────────────────────
            BButton(
              text: 'view_booking',
              onTap: onViewBooking,
              isOutline: false,
            ),
          ],
        ),
      ),
    );
  }

  // ── Green Check Circle with glow ring ─────────────────────────────────────

  Widget _buildCheckCircle(ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
          ),
        ),
        // Inner solid circle
        Container(
          width: 55.w,
          height: 55.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF4CAF50),
          ),
          child: Icon(
            Icons.check_rounded,
            color: theme.colorScheme.secondary,
            size: 32.sp,
          ),
        ),
      ],
    );
  }
}

// ── Helper to show the dialog ─────────────────────────────────────────────────

void showBookingConfirmedDialog({
  required String bookingId,
  required VoidCallback onViewBooking,
}) {
  Get.dialog(
    BookingConfirmedDialog(bookingId: bookingId, onViewBooking: onViewBooking),
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.5),
  );
}
