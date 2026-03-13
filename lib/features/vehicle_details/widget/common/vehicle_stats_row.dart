// lib/features/vehicle_details/presentation/widgets/common/vehicle_stats_row.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class VehicleStatsRow extends StatelessWidget {
  final List<StatItem> stats;

  const VehicleStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: stats.asMap().entries.map((e) {
        final i = e.key;
        final stat = e.value;
        final color = stat.color;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < stats.length - 1 ? 10.w : 0),
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.12),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: color.withValues(alpha: 0.20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(stat.icon, size: 16.sp, color: color),
                ),
                Gap(7.h),
                BText(
                  text: stat.labelKey,
                  fontSize: responsiveFont(en: 9.sp, ta: 8.sp),
                  color: theme.dividerColor,
                  isLocalized: true,
                ),
                Gap(3.h),
                BText(
                  text: stat.value,
                  fontSize: responsiveFont(en: 11.sp, ta: 9.sp),
                  fontWeight: FontWeight.w700,
                  isLocalized: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

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
