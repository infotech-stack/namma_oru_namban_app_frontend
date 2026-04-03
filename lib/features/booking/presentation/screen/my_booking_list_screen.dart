import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_entity.dart';
import 'package:userapp/features/booking/presentation/controller/my_booking_list_controller.dart';
import 'package:userapp/features/booking/presentation/widget/my_booking_list_shimmer.dart';
import 'package:userapp/utils/commons/tab_bar_controller/b_tabbar_controller.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class MyBookingListScreen extends GetView<MyBookingListController> {
  const MyBookingListScreen({super.key});

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
            Expanded(
              child: BTabController(
                tabs: controller.tabKeys,
                views: List.generate(
                  controller.tabKeys.length,
                  (i) => RefreshIndicator(
                    onRefresh: controller.refreshDetail,
                    child: _buildTabBody(i, theme),
                  ),
                ),
              ),
            ),
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
            text: 'my_booking',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.secondary,
            isLocalized: true,
          ),
        ],
      ),
    );
  }

  // ── Tab Body (one per tab) ────────────────────────────────────────────────

  Widget _buildTabBody(int tabIndex, ThemeData theme) {
    return Obx(() {
      // ── Loading state ─────────────────────────────────────────
      if (controller.isLoading.value && controller.bookings.isEmpty) {
        return const MyBookingListShimmer();
      }

      // ── Error state ───────────────────────────────────────────
      if (controller.errorMessage.value.isNotEmpty &&
          controller.bookings.isEmpty) {
        return _buildEmpty(theme); // or a dedicated error widget
      }

      final active = controller.activeBooking;
      final list = controller.bookingsForTab(tabIndex);

      if (list.isEmpty) return _buildEmpty(theme);

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            if (active != null && tabIndex == 0) ...[
              _ActiveBanner(booking: active, theme: theme),
              Gap(10.h),
            ],
            ...list.map(
              (b) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _BookingCard(
                  booking: b,
                  theme: theme,
                  onTap: () => controller.goToDetail(b),
                ),
              ),
            ),
            // ── Load more indicator ───────────────────────────
            if (controller.isLoading.value && controller.bookings.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                  strokeWidth: 2,
                ),
              ),
          ],
        ),
      );
    });
  }
  // ── Empty State ───────────────────────────────────────────────────────────

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 38.sp,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          Gap(16.h),
          BText(
            text: 'no_bookings_found',
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            isLocalized: true,
          ),
          Gap(6.h),
          BText(
            text: 'no_bookings_sub',
            fontSize: 12.sp,
            color: theme.dividerColor,
            isLocalized: true,
          ),
        ],
      ),
    );
  }
}

// ── Active Banner ─────────────────────────────────────────────────────────────

class _ActiveBanner extends StatelessWidget {
  final MyBookingEntity booking;
  final ThemeData theme;

  const _ActiveBanner({required this.booking, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(Routes.myBookingStatus, arguments: {'id': booking.id}),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Pulsing dot
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'active_trip_banner'.tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    booking.bookingRef,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: theme.colorScheme.secondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'view'.tr,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Booking Card ──────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final MyBookingEntity booking;
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
      case 'cancelled':
        return 'status_cancelled';
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
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Booking ID header ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 9.h),
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${'booking_id'.tr}: ${booking.bookingRef}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Vehicle + Status ────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.local_shipping_rounded,
                          color: theme.colorScheme.primary,
                          size: 22.sp,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BText(
                              text: booking.vehicleName,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              isLocalized: false,
                            ),
                            Gap(2.h),
                            BText(
                              text: booking.driverName,
                              fontSize: 11.sp,
                              color: theme.dividerColor,
                              isLocalized: false,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: _statusBg,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _statusKey.tr,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: _statusFg,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Gap(10.h),

                  // ── Route ───────────────────────────────────────────────
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                color: AppTheme.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 1.w,
                              height: 16.h,
                              color: theme.dividerColor.withValues(alpha: 0.3),
                            ),
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                color: AppTheme.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        Gap(8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.pickupAddress
                                    .split('\n')
                                    .first
                                    .split(',')
                                    .first,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gap(8.h),
                              Text(
                                booking.dropAddress
                                    .split('\n')
                                    .first
                                    .split(',')
                                    .first,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gap(10.h),

                  // ── Date + Amount ────────────────────────────────────────
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12.sp,
                        color: theme.dividerColor,
                      ),
                      Gap(4.w),
                      Text(
                        '${booking.displayDate}, ${booking.displayTime}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: theme.dividerColor,
                        ),
                      ),
                      const Spacer(),
                      BText(
                        text: booking.displayAmount,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                        isLocalized: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
