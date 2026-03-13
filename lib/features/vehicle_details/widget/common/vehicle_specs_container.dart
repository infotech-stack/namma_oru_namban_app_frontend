// lib/features/vehicle_details/presentation/widgets/common/vehicle_specs_container.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class VehicleSpecsContainer extends StatelessWidget {
  final String titleKey;
  final List<SpecItem> specs;
  final IconData? headerIcon;
  final Widget? customHeader;
  final Widget? customContent;

  const VehicleSpecsContainer({
    super.key,
    required this.titleKey,
    required this.specs,
    this.headerIcon,
    this.customHeader,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = theme.colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.withValues(alpha: 0.08), p.withValues(alpha: 0.03)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: p.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customHeader ??
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(7.r),
                    decoration: BoxDecoration(
                      color: p.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      headerIcon ?? Icons.tune_rounded,
                      size: 16.sp,
                      color: p,
                    ),
                  ),
                  Gap(10.w),
                  BText(
                    text: titleKey,
                    fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
                    fontWeight: FontWeight.w700,
                    isLocalized: true,
                  ),
                ],
              ),
          Gap(16.h),
          customContent ??
              Column(
                children: specs.map((spec) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Gap(10.w),
                        SizedBox(
                          width: 110.w,
                          child: BText(
                            text: spec.labelKey,
                            fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                            color: theme.dividerColor,
                            isLocalized: true,
                          ),
                        ),
                        Expanded(
                          child: BText(
                            text: spec.value,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            isLocalized: false,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
        ],
      ),
    );
  }
}

class SpecItem {
  final String labelKey;
  final String value;

  SpecItem({required this.labelKey, required this.value});
}
