// lib/features/vehicle_details/widget/common/vehicle_stats_row.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class StatItem {
  final IconData icon;
  final String labelKey;
  final String value;
  final Color color;

  StatItem({
    required this.icon,
    required this.labelKey,
    required this.value,
    required this.color,
  });
}

class VehicleStatsRow extends StatelessWidget {
  final List<StatItem> stats;

  const VehicleStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (stats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stats.map((stat) {
        return Container(
          width: 100.w, // Fixed width
          margin: EdgeInsets.only(right: 8.w),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: stat.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(stat.icon, size: 18.sp, color: stat.color),
              ),
              Gap(6.h),
              BText(
                text: stat.value,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                isLocalized: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Gap(3.h),
              BText(
                text: stat.labelKey,
                fontSize: 9.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                isLocalized: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
