// lib/features/driver/bookings/presentation/screen/driver_booking_status_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/booking/presentation/controller/driver_booking_status_controller.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class DriverBookingStatusScreen extends GetView<DriverBookingStatusController> {
  const DriverBookingStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.secondary,
        body: Column(
          children: [
            _buildAppBar(context, theme),
            Expanded(child: _buildBody(theme)),
            Obx(() => _buildActionButtons(theme)),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 16.w,
        right: 16.w,
        bottom: 14.h,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.secondary,
              size: 20.sp,
            ),
          ),
          Gap(12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BText(
                text: 'current_booking',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.secondary,
                isLocalized: true,
              ),
              Text(
                controller.booking.bookingRef,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      child: Obx(
        () => Column(
          children: [_buildStepper(theme), Gap(14.h), _buildBookingCard(theme)],
        ),
      ),
    );
  }

  // ── Stepper ───────────────────────────────────────────────────────────────

  Widget _buildStepper(ThemeData theme) {
    final steps = ['step_accepted'.tr, 'step_ongoing'.tr, 'step_done'.tr];

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'trip_status'.tr,
            style: TextStyle(fontSize: 11.sp, color: theme.dividerColor),
          ),
          Gap(12.h),
          Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                final lineIdx = i ~/ 2;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: controller.stepIndex > lineIdx
                        ? theme.colorScheme.primary
                        : theme.dividerColor.withValues(alpha: 0.25),
                  ),
                );
              }
              final si = i ~/ 2;
              final isDone = controller.stepIndex > si;
              final isActive = controller.stepIndex == si;

              return Column(
                children: [
                  Container(
                    width: 28.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? theme.colorScheme.primary
                          : isActive
                          ? theme.colorScheme.secondary
                          : theme.dividerColor.withValues(alpha: 0.12),
                      border: isActive
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: isDone
                          ? Icon(
                              Icons.check_rounded,
                              color: theme.colorScheme.secondary,
                              size: 14.sp,
                            )
                          : Icon(
                              isActive
                                  ? Icons.arrow_forward_rounded
                                  : Icons.circle,
                              color: isActive
                                  ? theme.colorScheme.primary
                                  : theme.dividerColor.withValues(alpha: 0.4),
                              size: isActive ? 14.sp : 6.sp,
                            ),
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    steps[si],
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: isDone || isActive
                          ? theme.colorScheme.primary
                          : theme.dividerColor,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Main Booking Card ─────────────────────────────────────────────────────

  Widget _buildBookingCard(ThemeData theme) {
    final b = controller.booking;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Vehicle Header ──────────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.local_shipping_rounded,
                    color: theme.colorScheme.primary,
                    size: 24.sp,
                  ),
                ),
                Gap(12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BText(
                      text: b.vehicleName,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      isLocalized: false,
                    ),
                    Gap(2.h),
                    BText(
                      text: b.userName,
                      fontSize: 11.sp,
                      color: theme.dividerColor,
                      isLocalized: false,
                    ),
                    Gap(4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: BText(
                        text: b.userMobile,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                        isLocalized: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Trip Details ──────────────────────────────────────────
                BText(
                  text: 'trip_details',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                  isLocalized: true,
                ),
                Gap(12.h),

                // Pickup dot line
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [_dot(AppTheme.green), _vertLine(theme)]),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _addrLabel('pickup'.tr, theme),
                        Gap(2.h),
                        _addrValue(b.pickupAddress),
                      ],
                    ),
                  ],
                ),

                // Drop dot
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dot(AppTheme.red),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _addrLabel('drop'.tr, theme),
                        Gap(2.h),
                        _addrValue(b.dropAddress),
                      ],
                    ),
                  ],
                ),

                Gap(14.h),
                Divider(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                  height: 1,
                ),
                Gap(12.h),

                // Info boxes
                Row(
                  children: [
                    Expanded(child: _infoBox(theme, 'date'.tr, '17 Feb')),
                    Gap(8.w),
                    Expanded(child: _infoBox(theme, 'time'.tr, '2:30 PM')),
                    Gap(8.w),
                    Expanded(child: _infoBox(theme, 'eta'.tr, '15 min')),
                  ],
                ),

                Gap(14.h),
                Divider(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                  height: 1,
                ),
                Gap(12.h),

                // ── Payment ───────────────────────────────────────────────
                BText(
                  text: 'payment',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                  isLocalized: true,
                ),
                Gap(10.h),
                Row(
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.payment_rounded,
                        color: theme.colorScheme.primary,
                        size: 20.sp,
                      ),
                    ),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BText(
                          text: b.paymentMethod ?? 'Cash Payment',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          isLocalized: false,
                        ),
                        BText(
                          text: 'pay_on_arrival',
                          fontSize: 10.sp,
                          color: theme.dividerColor,
                          isLocalized: true,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'total'.tr,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: theme.dividerColor,
                          ),
                        ),
                        BText(
                          text: b.displayAmount,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                          isLocalized: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _dot(Color color) => Container(
    width: 14.w,
    height: 14.h,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.25),
      shape: BoxShape.circle,
    ),
    child: Container(
      width: 7.w,
      height: 7.h,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );

  Widget _vertLine(ThemeData theme) => Container(
    width: 1.5.w,
    height: 38.h,
    color: theme.dividerColor.withValues(alpha: 0.25),
  );

  Widget _addrLabel(String label, ThemeData theme) => Text(
    label,
    style: TextStyle(fontSize: 10.sp, color: theme.dividerColor),
  );

  Widget _addrValue(String val) => SizedBox(
    width: 220.w,
    child: BText(
      text: val,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      isLocalized: false,
    ),
  );

  Widget _infoBox(ThemeData theme, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: theme.dividerColor),
          ),
          Gap(4.h),
          BText(
            text: value,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            isLocalized: false,
          ),
        ],
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────

  Widget _buildActionButtons(ThemeData theme) {
    if (controller.isLoading.value) {
      return Container(
        color: theme.colorScheme.secondary,
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    return Container(
      color: theme.colorScheme.secondary,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.currentStatus.value == 'pending') ...[
            BButton(
              text: 'accept_booking',
              onTap: controller.acceptBooking,
              prefixIcon: const Icon(Icons.check_circle_outline_rounded),
            ),
            Gap(8.h),
            BButton(
              text: 'reject_booking',
              onTap: () => _showRejectDialog(theme),
              isOutline: true,
              prefixIcon: Icon(Icons.cancel_outlined, color: AppTheme.red),
            ),
          ],
          if (controller.currentStatus.value == 'accepted') ...[
            BButton(
              text: 'start_trip',
              onTap: controller.startTrip,
              prefixIcon: const Icon(Icons.play_circle_outline_rounded),
            ),
            Gap(8.h),
            BButton(
              text: 'call_user',
              onTap: controller.callUser,
              isOutline: true,
              prefixIcon: Icon(Icons.call, color: theme.primaryColor),
            ),
          ],
          if (controller.currentStatus.value == 'ongoing') ...[
            BButton(
              text: 'complete_trip',
              onTap: controller.completeTrip,
              prefixIcon: const Icon(Icons.flag_outlined),
            ),
            Gap(8.h),
            BButton(
              text: 'call_user',
              onTap: controller.callUser,
              isOutline: true,
              prefixIcon: Icon(Icons.call, color: theme.primaryColor),
            ),
          ],
          if (controller.currentStatus.value == 'completed' ||
              controller.currentStatus.value == 'rejected')
            BButton(
              text: 'back_to_bookings',
              onTap: Get.back,
              isOutline: true,
              prefixIcon: Icon(
                Icons.arrow_back_rounded,
                color: theme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  // ── Reject Dialog ─────────────────────────────────────────────────────────

  void _showRejectDialog(ThemeData theme) {
    final reasonCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'reject_booking_title'.tr,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'reason_optional'.tr,
              style: TextStyle(fontSize: 12.sp, color: theme.dividerColor),
            ),
            Gap(8.h),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'reason_hint'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: theme.dividerColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.rejectBooking(reason: reasonCtrl.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'reject'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
