// lib/features/booking/presentation/widgets/common/booking_fare_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';


class BookingFareCard extends StatelessWidget {
  final List<FareRowItem> fareRows;
  final String totalEstimate;
  final String? noteKey;

  const BookingFareCard({
    super.key,
    required this.fareRows,
    required this.totalEstimate,
    this.noteKey = 'fare_note',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BookingCardDecoration(theme: theme),
      child: Column(
        children: [
          ...fareRows.map(
            (item) => Column(
              children: [
                _buildFareRow(
                  theme,
                  item.label,
                  item.value,
                  isLocalized: item.isLocalized,
                ),
                if (item != fareRows.last) Gap(8.h),
              ],
            ),
          ),
          Gap(10.h),
          Divider(color: theme.dividerColor.withValues(alpha: 0.2)),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BText(
                text: 'total_estimate',
                fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                isLocalized: true,
              ),
              BText(
                text: totalEstimate,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                isLocalized: false,
              ),
            ],
          ),
          if (noteKey != null) ...[
            Gap(12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFFF8F00),
                    size: 16,
                  ),
                  Gap(8.w),
                  Expanded(
                    child: BText(
                      text: noteKey!,
                      fontSize: 11.sp,
                      color: const Color(0xFF7B5800),
                      isLocalized: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFareRow(
    ThemeData theme,
    String label,
    String value, {
    bool isLocalized = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isLocalized
            ? BText(
                text: label,
                fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                color: theme.dividerColor,
                isLocalized: true,
              )
            : Text(
                label,
                style: TextStyle(fontSize: 13.sp, color: theme.dividerColor),
              ),
        BText(
          text: value,
          fontSize: 13.sp,
          color: theme.colorScheme.onSurface,
          isLocalized: false,
        ),
      ],
    );
  }
}

class FareRowItem {
  final String label;
  final String value;
  final bool isLocalized;

  FareRowItem({
    required this.label,
    required this.value,
    this.isLocalized = true,
  });
}
