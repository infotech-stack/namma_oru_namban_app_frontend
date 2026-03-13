// lib/features/booking/presentation/widgets/common/booking_driver_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';

class BookingDriverCard extends StatelessWidget {
  final String driverName;
  final double driverRating;
  final String vehicleNumber;
  final String experience;
  final VoidCallback onCallDriver;

  const BookingDriverCard({
    super.key,
    required this.driverName,
    required this.driverRating,
    required this.vehicleNumber,
    required this.experience,
    required this.onCallDriver,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BookingCardDecoration(theme: theme),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: theme.colorScheme.primary,
                  size: 28.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BText(
                      text: driverName,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      isLocalized: false,
                    ),
                    Gap(3.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFC107),
                          size: 13.sp,
                        ),
                        Gap(3.w),
                        Expanded(
                          child: BText(
                            text:
                                '$driverRating ${'rating'.tr} • ${'verified_driver'.tr}',
                            fontSize: 11.sp,
                            color: theme.dividerColor,
                            isLocalized: false,
                          ),
                        ),
                      ],
                    ),
                    Gap(2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: theme.dividerColor,
                          size: 13.sp,
                        ),
                        Gap(3.w),
                        BText(
                          text: experience,
                          fontSize: 11.sp,
                          color: theme.dividerColor,
                          isLocalized: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(14.h),
          GestureDetector(
            onTap: onCallDriver,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call_rounded,
                    color: theme.colorScheme.onSurface,
                    size: 16.sp,
                  ),
                  Gap(6.w),
                  BText(
                    text: 'call_driver',
                    fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    isLocalized: true,
                  ),
                ],
              ),
            ),
          ),
          Gap(10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: BText(
                text: vehicleNumber,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                isLocalized: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
