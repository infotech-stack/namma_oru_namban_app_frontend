// lib/features/driver/bookings/presentation/screen/driver_booking_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/booking/data/model/driver_booking_model.dart';
import 'package:userapp/features/booking/presentation/controller/driver_booking_list_controller.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class DriverBookingListScreen extends GetView<DriverBookingListController> {
  const DriverBookingListScreen({super.key});

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
            _buildTabs(theme),
            Expanded(child: _buildBody(theme)),
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
          BText(
            text: 'my_bookings',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.secondary,
            isLocalized: true,
          ),
        ],
      ),
    );
  }

  // ── Tabs ──────────────────────────────────────────────────────────────────

  Widget _buildTabs(ThemeData theme) {
    return Container(
      color: theme.colorScheme.secondary,
      child: Obx(
        () => Row(
          children: List.generate(
            controller.tabKeys.length,
            (i) => Expanded(
              child: GestureDetector(
                onTap: () => controller.selectTab(i),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: controller.selectedTab.value == i
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    controller.tabKeys[i].tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: controller.selectedTab.value == i
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: controller.selectedTab.value == i
                          ? theme.colorScheme.primary
                          : theme.dividerColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody(ThemeData theme) {
    return Obx(() {
      final active = controller.activeBooking;
      final bookings = controller.filteredBookings;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            if (active != null && controller.selectedTab.value == 0) ...[
              _ActiveBanner(booking: active, theme: theme),
              Gap(10.h),
            ],
            ...bookings.map(
              (b) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _BookingCard(
                  booking: b,
                  theme: theme,
                  onTap: () => controller.goToStatus(b),
                ),
              ),
            ),
            if (bookings.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 60.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48.sp,
                      color: theme.dividerColor,
                    ),
                    Gap(12.h),
                    BText(
                      text: 'no_bookings_found',
                      fontSize: 14.sp,
                      color: theme.dividerColor,
                      isLocalized: true,
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}

// ── Active Banner ─────────────────────────────────────────────────────────────

class _ActiveBanner extends StatelessWidget {
  final DriverBookingModel booking;
  final ThemeData theme;

  const _ActiveBanner({required this.booking, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.myBookingStatus, arguments: booking),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: const BoxDecoration(
                color: Color(0xFFA3E635),
                shape: BoxShape.circle,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: Text(
                '1 ${'active_trip_banner'.tr} — ${booking.bookingRef}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: theme.colorScheme.secondary.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Booking Card ──────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final DriverBookingModel booking;
  final ThemeData theme;
  final VoidCallback onTap;

  const _BookingCard({
    required this.booking,
    required this.theme,
    required this.onTap,
  });

  Color get _statusBg {
    switch (booking.status) {
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'accepted':
      case 'ongoing':
        return const Color(0xFFEDE9FE);
      case 'completed':
        return const Color(0xFFD1FAE5);
      default:
        return const Color(0xFFFEE2E2);
    }
  }

  Color get _statusFg {
    switch (booking.status) {
      case 'pending':
        return const Color(0xFF92400E);
      case 'accepted':
      case 'ongoing':
        return const Color(0xFF5B21B6);
      case 'completed':
        return const Color(0xFF065F46);
      default:
        return const Color(0xFF991B1B);
    }
  }

  String get _statusKey {
    switch (booking.status) {
      case 'pending':
        return 'status_pending';
      case 'accepted':
        return 'status_accepted';
      case 'ongoing':
        return 'status_ongoing';
      case 'completed':
        return 'status_completed';
      default:
        return 'status_rejected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ref + Status badge
            Row(
              children: [
                Text(
                  booking.bookingRef,
                  style: TextStyle(fontSize: 11.sp, color: theme.dividerColor),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: _statusBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _statusKey.tr,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: _statusFg,
                    ),
                  ),
                ),
              ],
            ),

            Gap(8.h),

            // Truck icon + vehicle + user
            Row(
              children: [
                Container(
                  width: 38.w,
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.local_shipping_rounded,
                    color: theme.colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
                Gap(10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BText(
                      text: booking.vehicleName,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      isLocalized: false,
                    ),
                    BText(
                      text: booking.userName,
                      fontSize: 11.sp,
                      color: theme.dividerColor,
                      isLocalized: false,
                    ),
                  ],
                ),
              ],
            ),

            Gap(8.h),

            // Route row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: AppTheme.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(6.w),
                  Expanded(
                    child: Text(
                      booking.pickupAddress.split(',').first,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 12.sp,
                    color: theme.dividerColor,
                  ),
                  Gap(6.w),
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: const BoxDecoration(
                      color: AppTheme.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Gap(6.w),
                  Expanded(
                    child: Text(
                      booking.dropAddress.split(',').first,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            Gap(8.h),

            // Date + amount
            Row(
              children: [
                Text(
                  DateFormat('dd MMM, hh:mm a').format(booking.createdAt),
                  style: TextStyle(fontSize: 10.sp, color: theme.dividerColor),
                ),
                const Spacer(),
                BText(
                  text: booking.displayAmount,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                  isLocalized: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
