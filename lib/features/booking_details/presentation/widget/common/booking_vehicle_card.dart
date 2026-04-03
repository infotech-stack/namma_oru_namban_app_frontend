// lib/features/booking/presentation/widgets/common/booking_vehicle_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';
import 'package:userapp/utils/commons/catch_image/app_catch_image.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class BookingVehicleCard extends StatelessWidget {
  final String vehicleName;
  final String vehicleImagePath;
  final String pricePerKm;
  final String eta;
  final String? capacity1;
  final String? capacity2;
  final String driverName;
  final double driverRating;
  final IconData vehicleIcon;
  final VoidCallback? onCallDriver;

  const BookingVehicleCard({
    super.key,
    required this.vehicleName,
    required this.vehicleImagePath,
    required this.pricePerKm,
    required this.eta,
    this.capacity1,
    this.capacity2,
    required this.driverName,
    required this.driverRating,
    required this.vehicleIcon,
    this.onCallDriver,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BookingCardDecoration(
        theme: theme,
      ).copyWith(border: Border.all(color: p.withValues(alpha: 0.12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Vehicle Image Container
              Container(
                width: 90.w,
                height: 78.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      p.withValues(alpha: 0.12),
                      p.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(color: p.withValues(alpha: 0.15)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: _buildVehicleImage(p),
                ),
              ),
              Gap(12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BText(
                      text: vehicleName,
                      fontSize: responsiveFont(en: 15.sp, ta: 13.sp),
                      fontWeight: FontWeight.w800,
                      isLocalized: false,
                    ),
                    Gap(6.h),

                    Row(
                      children: [_buildPriceTag(p), Gap(6.w)],

                      ///_buildEtaTag()
                    ),
                    if (capacity1 != null) ...[
                      Gap(6.h),
                      _buildCapacityRow(theme),
                    ],
                  ],
                ),
              ),
            ],
          ),

          Gap(12.h),
          _buildDivider(p),
          Gap(10.h),

          _buildDriverRow(theme, p),
        ],
      ),
    );
  }

  // ✅ Vehicle Image Builder with BCachedImage
  Widget _buildVehicleImage(Color primaryColor) {
    // No image path - show icon
    if (vehicleImagePath.isEmpty) {
      return Center(
        child: Icon(vehicleIcon, color: primaryColor, size: 32.sp),
      );
    }

    // ✅ Use BCachedImage for network images
    return BCachedImage.document(
      imageUrl: vehicleImagePath,
      width: double.infinity,
      height: 78.h,
      borderRadius: 12,
    );
  }

  Widget _buildPriceTag(Color primaryColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: primaryColor.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(Icons.currency_rupee_rounded, size: 10.sp, color: primaryColor),
          BText(
            text: pricePerKm,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: primaryColor,
            isLocalized: false,
          ),
        ],
      ),
    );
  }

  Widget _buildEtaTag() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E88E5).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: const Color(0xFF1E88E5).withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 10.sp,
            color: const Color(0xFF1E88E5),
          ),
          Gap(3.w),
          BText(
            text: eta,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E88E5),
            isLocalized: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityRow(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 11.sp,
          color: theme.dividerColor,
        ),
        Gap(4.w),
        Expanded(
          child: BText(
            text: capacity2 != null ? '$capacity1 • $capacity2' : capacity1!,
            fontSize: 11.sp,
            color: theme.dividerColor,
            isLocalized: false,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(Color primaryColor) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            primaryColor.withValues(alpha: 0.20),
            primaryColor.withValues(alpha: 0.20),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildDriverRow(ThemeData theme, Color primaryColor) {
    return Row(
      children: [
        Container(
          width: 30.r,
          height: 30.r,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withValues(alpha: 0.70)],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              driverName.isNotEmpty ? driverName[0].toUpperCase() : 'D',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Gap(8.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BText(
                text: driverName,
                fontSize: responsiveFont(en: 12.sp, ta: 11.sp),
                fontWeight: FontWeight.w700,
                isLocalized: false,
              ),
              BText(
                text: 'assigned_driver',
                fontSize: 9.sp,
                color: theme.dividerColor,
                isLocalized: true,
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB300).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFFFFB300).withValues(alpha: 0.30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                size: 12.sp,
                color: const Color(0xFFFFB300),
              ),
              Gap(3.w),
              BText(
                text: driverRating.toString(),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFFB300),
                isLocalized: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
