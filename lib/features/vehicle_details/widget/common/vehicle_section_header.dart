// lib/features/vehicle_details/presentation/widgets/common/vehicle_section_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class VehicleSectionHeader extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  final Color? iconColor;
  final double? iconSize;
  final double? fontSize;

  const VehicleSectionHeader({
    super.key,
    required this.icon,
    required this.titleKey,
    this.iconColor,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.primary;

    return Row(
      children: [
        Icon(icon, size: iconSize ?? 18.sp, color: color),
        Gap(8.w),
        Expanded(
          child: BText(
            text: titleKey,
            fontSize: fontSize ?? responsiveFont(en: 14.sp, ta: 12.sp),
            fontWeight: FontWeight.w700,
            isLocalized: true,
          ),
        ),
      ],
    );
  }
}
