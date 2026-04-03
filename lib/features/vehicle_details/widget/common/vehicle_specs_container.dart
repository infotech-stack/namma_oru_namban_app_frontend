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
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 HEADER
          customHeader ??
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: p.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      headerIcon ?? Icons.tune_rounded,
                      size: 18.sp,
                      color: p,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: BText(
                      text: titleKey,
                      fontSize: responsiveFont(en: 15.sp, ta: 13.sp),
                      fontWeight: FontWeight.w700,
                      isLocalized: true,
                    ),
                  ),
                ],
              ),

          Gap(16.h),

          /// 🔥 CONTENT
          customContent ??
              Column(
                children: List.generate(specs.length, (index) {
                  final spec = specs[index];

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          /// 👉 Left Label
                          SizedBox(
                            width: 120.w,
                            child: BText(
                              text: spec.labelKey,
                              fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                              color: Colors.grey[600],
                              isLocalized: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          /// 👉 Right Value
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft, // 👈 IMPORTANT
                              child: BText(
                                text: spec.value,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                isLocalized: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// 🔥 Divider (except last)
                      if (index != specs.length - 1) ...[
                        Gap(10.h),
                        Divider(
                          height: 1,
                          thickness: 0.6,
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                        Gap(10.h),
                      ],
                    ],
                  );
                }),
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
