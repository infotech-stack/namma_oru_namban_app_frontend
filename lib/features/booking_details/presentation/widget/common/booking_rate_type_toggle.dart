// lib/features/booking/presentation/widgets/common/booking_rate_type_toggle.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';

class BookingRateTypeToggle extends StatelessWidget {
  final List<RateTypeOption> options;
  final String selectedType;
  final Function(String) onTypeSelected;
  final int crossAxisCount;

  const BookingRateTypeToggle({
    super.key,
    required this.options,
    required this.selectedType,
    required this.onTypeSelected,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BookingCardDecoration(theme: theme),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: List.generate(options.length, (index) {
            final option = options[index];
            final isSelected = selectedType == option.type;

            return Expanded(
              child: index > 0
                  ? Row(
                      children: [
                        Gap(12.w),
                        Expanded(
                          child: _buildButton(theme, option, isSelected),
                        ),
                      ],
                    )
                  : _buildButton(theme, option, isSelected),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildButton(ThemeData theme, RateTypeOption option, bool isSelected) {
    return GestureDetector(
      onTap: () => onTypeSelected(option.type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.colorScheme.primary, width: 1.5),
        ),
        child: Center(
          child: BText(
            text: option.labelKey,
            fontSize: responsiveFont(en: option.fontSize ?? 13.sp, ta: 10.sp),
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : theme.colorScheme.primary,
            isLocalized: true,
          ),
        ),
      ),
    );
  }
}

class RateTypeOption {
  final String type;
  final String labelKey;
  final double? fontSize;

  RateTypeOption({required this.type, required this.labelKey, this.fontSize});
}
