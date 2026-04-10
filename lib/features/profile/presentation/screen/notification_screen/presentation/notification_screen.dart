// lib/features/notification/presentation/screen/notification_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/entities/notification_entity.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/presentation/notification_controller.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

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
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
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
          Expanded(
            child: BText(
              text: 'notifications',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.secondary,
              isLocalized: true,
            ),
          ),
          // Unread badge
          Obx(() {
            if (controller.unreadCount.value == 0) {
              return const SizedBox.shrink();
            }
            return Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${controller.unreadCount.value}',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.secondary,
                ),
              ),
            );
          }),
          // Mark all read
          Obx(() {
            if (controller.unreadCount.value == 0 ||
                controller.isMarkingAll.value) {
              return const SizedBox.shrink();
            }
            return GestureDetector(
              onTap: controller.markAllAsRead,
              child: Text(
                'mark_all_read'.tr,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.85),
                ),
              ),
            );
          }),
          // Clear all
          Obx(() {
            if (controller.notifications.isEmpty) {
              return const SizedBox.shrink();
            }
            return GestureDetector(
              onTap: controller.showClearDialog,
              child: Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: controller.isClearing.value
                    ? SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.secondary,
                        ),
                      )
                    : Icon(
                        Icons.delete_outline_rounded,
                        color: theme.colorScheme.secondary,
                        size: 20.sp,
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────
  Widget _buildBody(ThemeData theme) {
    return Obx(() {
      // Loading
      if (controller.isLoading.value) {
        return _buildShimmer(theme);
      }

      // Error
      if (controller.errorMessage.value.isNotEmpty) {
        return _buildError(theme);
      }

      // Empty
      if (controller.notifications.isEmpty) {
        return _buildEmpty(theme);
      }

      // List
      return RefreshIndicator(
        onRefresh: controller.fetchNotifications,
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.secondary,
        strokeWidth: 2,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: theme.dividerColor.withValues(alpha: 0.08),
            indent: 16.w,
            endIndent: 16.w,
          ),
          itemBuilder: (_, i) => _NotificationTile(
            notification: controller.notifications[i],
            theme: theme,
            onTap: () =>
                controller.onNotificationTap(controller.notifications[i]),
          ),
        ),
      );
    });
  }

  // ── Shimmer ───────────────────────────────────────────────────
  Widget _buildShimmer(ThemeData theme) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: 6,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: theme.dividerColor.withValues(alpha: 0.08),
        indent: 16.w,
        endIndent: 16.w,
      ),
      itemBuilder: (_, __) => _ShimmerTile(theme: theme),
    );
  }

  // ── Empty State ───────────────────────────────────────────────
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
              Icons.notifications_off_outlined,
              size: 38.sp,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          Gap(16.h),
          BText(
            text: 'no_notifications',
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            isLocalized: true,
          ),
          Gap(6.h),
          BText(
            text: 'no_notifications_sub',
            fontSize: 12.sp,
            color: theme.dividerColor,
            isLocalized: true,
          ),
        ],
      ),
    );
  }

  // ── Error State ───────────────────────────────────────────────
  Widget _buildError(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.sp,
            color: theme.dividerColor,
          ),
          Gap(12.h),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: theme.dividerColor),
          ),
          Gap(16.h),
          ElevatedButton(
            onPressed: controller.fetchNotifications,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            ),
            child: Text(
              'retry'.tr,
              style: TextStyle(
                fontSize: 13.sp,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notification Tile ─────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final ThemeData theme;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.theme,
    required this.onTap,
  });

  Color get _typeColor {
    switch (notification.type) {
      case 'trip_completed':
        return const Color(0xFF059669);
      case 'trip_started':
        return const Color(0xFF2563EB);
      case 'booking_accepted':
        return const Color(0xFF7C3AED);
      case 'booking_rejected':
        return const Color(0xFFDC2626);
      case 'booking_cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData get _typeIcon {
    switch (notification.type) {
      case 'trip_completed':
        return Icons.check_circle_rounded;
      case 'trip_started':
        return Icons.directions_car_rounded;
      case 'booking_accepted':
        return Icons.thumb_up_rounded;
      case 'booking_rejected':
        return Icons.cancel_rounded;
      case 'booking_cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : _typeColor.withValues(alpha: 0.04),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icon ───────────────────────────────────────────
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: _typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(_typeIcon, color: _typeColor, size: 22.sp),
            ),

            Gap(12.w),

            // ── Content ────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Gap(8.w),
                      // Time + unread dot
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            notification.displayTime.tr,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: theme.dividerColor,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            Gap(4.h),
                            Container(
                              width: 7.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                color: _typeColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),

                  Gap(4.h),

                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.dividerColor,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // ── Booking ref chip ──────────────────────────
                  if (notification.data.bookingRef != null) ...[
                    Gap(8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: _typeColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        notification.data.bookingRef!,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: _typeColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shimmer Tile ──────────────────────────────────────────────────────────────

class _ShimmerTile extends StatelessWidget {
  final ThemeData theme;
  const _ShimmerTile({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 13.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                    Gap(40.w),
                    Container(
                      width: 30.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                Container(
                  width: double.infinity,
                  height: 11.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                Gap(6.h),
                Container(
                  width: 180.w,
                  height: 11.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
