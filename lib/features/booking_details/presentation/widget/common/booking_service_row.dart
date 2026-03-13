// lib/features/booking/presentation/widgets/common/booking_service_row.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class BookingServiceRow extends StatelessWidget {
  final String labelKey;
  final String price;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isFirst;
  final bool isLast;
  final bool isPriceColored;
  final Color? priceColor;

  const BookingServiceRow({
    super.key,
    required this.labelKey,
    required this.price,
    required this.value,
    required this.onChanged,
    this.isFirst = false,
    this.isLast = false,
    this.isPriceColored = false,
    this.priceColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: value ? theme.colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: value
                      ? theme.colorScheme.primary
                      : theme.dividerColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: value
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 13.sp)
                  : const SizedBox.shrink(),
            ),
            Gap(12.w),
            Expanded(
              child: BText(
                text: labelKey,
                fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
                isLocalized: true,
              ),
            ),
            BText(
              text: price,
              fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
              fontWeight: FontWeight.w600,
              color:
                  priceColor ??
                  (isPriceColored ? theme.colorScheme.primary : AppTheme.green),
              isLocalized: isPriceColored,
            ),
          ],
        ),
      ),
    );
  }
}

class BookingServiceDivider extends StatelessWidget {
  final ThemeData theme;

  const BookingServiceDivider({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Divider(
        color: theme.dividerColor.withValues(alpha: 0.15),
        height: 1,
      ),
    );
  }
}
