// lib/features/booking/presentation/widgets/common/booking_trip_details_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/booking_details/presentation/controller/unified_booking_controller.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_info_box.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';

class BookingTripDetailsCard extends StatelessWidget {
  final TextEditingController pickupController;
  final TextEditingController dropController;
  final String distance;
  final String time;
  final VoidCallback? onPickupChanged;
  final VoidCallback? onDropChanged;

  const BookingTripDetailsCard({
    super.key,
    required this.pickupController,
    required this.dropController,
    required this.distance,
    required this.time,
    this.onPickupChanged,
    this.onDropChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookingController = Get.find<UnifiedBookingController>();

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BookingCardDecoration(theme: theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Pickup Field ──
          _buildLabel(theme, 'pickup_address'),
          Gap(6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                // 📍 Location Icon with background
                Container(
                  margin: EdgeInsets.only(left: 8.w),
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppTheme.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: AppTheme.red,
                    size: 18.sp,
                  ),
                ),

                SizedBox(width: 10.w),

                // ✍️ TextField
                Expanded(
                  child: TextField(
                    controller: pickupController,
                    decoration: InputDecoration(
                      hintText: 'Enter pickup location',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (_) => onPickupChanged?.call(),
                  ),
                ),

                // 📡 Divider (nice UX touch)
                Container(
                  height: 24.h,
                  width: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),

                // 📍 GPS Button / Loader
                Obx(
                  () => AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: bookingController.isLoadingLocation.value
                        ? Padding(
                            padding: EdgeInsets.all(12.w),
                            child: SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.my_location_rounded,
                              color: theme.colorScheme.primary,
                              size: 20.sp,
                            ),
                            onPressed: bookingController.fetchCurrentLocation,
                          ),
                  ),
                ),
              ],
            ),
          ),

          Gap(14.h),

          // ── Drop Field ──
          _buildLabel(theme, 'drop_address'),
          Gap(6.h),
          GestureDetector(
            onTap: () async {
              final result = await Get.toNamed(Routes.locationPicker);
              if (result != null && result is Map) {
                await bookingController.setDropLocation(
                  result['address'] as String,
                  result['lat'] as double,
                  result['lng'] as double,
                );
                onDropChanged?.call();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
              ),
              // ✅ TextEditingController → ValueListenableBuilder use பண்ணு
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: dropController,
                builder: (context, value, _) {
                  final isEmpty = value.text.isEmpty;
                  return Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: theme.dividerColor,
                        size: 20.sp,
                      ),
                      Gap(10.w),
                      Expanded(
                        child: Text(
                          isEmpty ? 'hint_drop'.tr : value.text,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isEmpty ? Colors.grey[400] : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(8.w),
                      Icon(
                        Icons.map_rounded,
                        size: 18.sp,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          Gap(14.h),

          // ── Distance & Time ──
          // ✅ estimatedDistanceKm → booking is Rxn, Obx ok
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  final km =
                      bookingController.booking.value?.estimatedDistanceKm;
                  return BookingInfoBox(
                    label: 'distance',
                    value: (km != null && km > 0)
                        ? '${km.toStringAsFixed(1)} km'
                        : distance,
                    valueColor: theme.colorScheme.primary,
                  );
                }),
              ),
              Gap(12.w),
              Expanded(
                child: BookingInfoBox(
                  label: 'time',
                  value: time,
                  valueColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(ThemeData theme, String labelKey) {
    return Text(
      labelKey.tr,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}
