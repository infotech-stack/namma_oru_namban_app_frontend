import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/booking/presentation/controller/booking_controller.dart';
import 'package:userapp/features/booking/presentation/widget/booking_model_widget.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class MyBookingScreen extends GetView<MyBookingController> {
  const MyBookingScreen({super.key});

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
            _buildHeader(theme),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Obx(() {
                  final b = controller.booking.value;
                  return Column(
                    children: [
                      _buildBookingCard(theme, b),
                      Gap(20.h),
                      _buildCallButton(theme),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(theme),
      ),
    );
  }

  // ── Purple Header ──────────────────────────────────────────────────────────

  Widget _buildHeader(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary,
      padding: EdgeInsets.only(
        top: 52.h,
        left: 16.w,
        right: 16.w,
        bottom: 20.h,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.secondary,
              size: 20.sp,
            ),
          ),
          Gap(12.w),
          BText(
            text: 'my_booking',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.secondary,
            isLocalized: true,
          ),
        ],
      ),
    );
  }

  // ── Main Booking Card ──────────────────────────────────────────────────────

  Widget _buildBookingCard(ThemeData theme, BookingModel b) {
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
          // Booking ID
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Center(
              child: Text(
                '${'booking_id'.tr}: ${b.bookingId}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Row
                Row(
                  children: [
                    // Truck image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: b.imagePath != null
                          ? Image.asset(
                              b.imagePath!,
                              width: 60.w,
                              height: 60.h,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60.w,
                              height: 60.h,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              child: Icon(
                                Icons.local_shipping_rounded,
                                color: theme.colorScheme.primary,
                                size: 30.sp,
                              ),
                            ),
                    ),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BText(
                          text: b.vehicleName,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          isLocalized: false,
                        ),
                        Gap(3.h),
                        BText(
                          text: b.driverName,
                          fontSize: 12.sp,
                          color: theme.dividerColor,
                          isLocalized: false,
                        ),
                        Gap(5.h),
                        // Vehicle Number Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: BText(
                            text: b.vehicleNumber,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                            isLocalized: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Gap(16.h),
                Divider(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                  height: 1,
                ),
                Gap(14.h),

                // Trip Details
                BText(
                  text: 'trip_details',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                  isLocalized: true,
                ),
                Gap(12.h),

                // Pickup
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 1.5.w,
                          height: 40.h,
                          color: theme.dividerColor.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BText(
                          text: 'pickup',
                          fontSize: 10.sp,
                          color: theme.dividerColor,
                          isLocalized: true,
                        ),
                        Gap(2.h),
                        BText(
                          text: b.pickup,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          isLocalized: false,
                        ),
                      ],
                    ),
                  ],
                ),

                // Drop
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BText(
                          text: 'drop',
                          fontSize: 10.sp,
                          color: theme.dividerColor,
                          isLocalized: true,
                        ),
                        Gap(2.h),
                        BText(
                          text: b.drop,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          isLocalized: false,
                        ),
                      ],
                    ),
                  ],
                ),

                Gap(14.h),

                // Date / Time / ETA
                Row(
                  children: [
                    Expanded(child: _infoBox(theme, 'date', b.date)),
                    Gap(10.w),
                    Expanded(child: _infoBox(theme, 'time', b.time)),
                    Gap(10.w),
                    Expanded(
                      child: _infoBox(theme, 'eta', '${b.eta} ${'mins'.tr}'),
                    ),
                  ],
                ),

                Gap(16.h),
                Divider(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                  height: 1,
                ),
                Gap(14.h),

                // Payment
                BText(
                  text: 'payment',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                  isLocalized: true,
                ),
                Gap(12.h),
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
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
                          text: b.paymentMethod,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          isLocalized: false,
                        ),
                        BText(
                          text: b.paymentNote,
                          fontSize: 11.sp,
                          color: theme.dividerColor,
                          isLocalized: false,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BText(
                          text: 'total',
                          fontSize: 10.sp,
                          color: theme.dividerColor,
                          isLocalized: true,
                        ),
                        BText(
                          text: b.totalAmount,
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

  Widget _infoBox(ThemeData theme, String labelKey, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          BText(
            text: labelKey,
            fontSize: 10.sp,
            color: theme.dividerColor,
            isLocalized: true,
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

  // ── Call Driver Button ─────────────────────────────────────────────────────

  Widget _buildCallButton(ThemeData theme) {
    return GestureDetector(
      onTap: controller.onCallDriver,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: theme.colorScheme.primary, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_rounded,
              color: theme.colorScheme.primary,
              size: 20.sp,
            ),
            Gap(8.w),
            BText(
              text: 'call_driver',
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              isLocalized: true,
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Nav ─────────────────────────────────────────────────────────────

  Widget _buildBottomNavBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(theme, Icons.home_rounded, 'home', 0),
              _navItem(theme, Icons.calendar_month_outlined, 'my_booking', 1),
              _navItem(theme, Icons.person_outline_rounded, 'profile', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(ThemeData theme, IconData icon, String labelKey, int index) {
    final isSelected = index == 1; // My Booking is active
    return GestureDetector(
      onTap: () {
        if (index == 0) Get.back();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
            ),
            Gap(3.h),
            BText(
              text: labelKey,
              fontSize: 10.sp,
              isLocalized: true,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}
