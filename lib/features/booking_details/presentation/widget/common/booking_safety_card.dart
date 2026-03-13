// lib/features/booking/presentation/widgets/common/booking_safety_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';

class BookingSafetyCard extends StatelessWidget {
  final List<SafetyItem> items;

  const BookingSafetyCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Row(
            children: [
              if (items.indexOf(item) > 0) Gap(12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 10.w,
                  ),
                  decoration: BookingCardDecoration(theme: theme),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: item.bgColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 20.sp,
                        ),
                      ),
                      Gap(8.h),
                      BText(
                        text: item.labelKey,
                        fontSize:
                            item.fontSize ??
                            responsiveFont(en: 12.sp, ta: 10.sp),
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        isLocalized: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class SafetyItem {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String labelKey;
  final double? fontSize;

  SafetyItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.labelKey,
    this.fontSize,
  });
}
