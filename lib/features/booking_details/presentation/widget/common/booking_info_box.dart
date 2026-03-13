// lib/features/booking/presentation/widgets/common/booking_info_box.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class BookingInfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const BookingInfoBox({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          BText(
            text: label,
            fontSize: 10.sp,
            color: theme.dividerColor,
            isLocalized: true,
          ),
          Gap(4.h),
          BText(
            text: value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: valueColor ?? theme.colorScheme.onSurface,
            isLocalized: false,
          ),
        ],
      ),
    );
  }
}
