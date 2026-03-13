// lib/features/booking/presentation/widgets/common/booking_instructions_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/utils/commons/textfield/b_textfiled.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';

class BookingInstructionsCard extends StatelessWidget {
  final TextEditingController controller;
  final String hintTextKey;
  final String exampleTextKey;

  const BookingInstructionsCard({
    super.key,
    required this.controller,
    required this.hintTextKey,
    required this.exampleTextKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BookingCardDecoration(theme: theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BTextField(
            controller: controller,
            labelText: 'special_instructions',
            hintText: hintTextKey,
            isLocalized: true,
            maxLines: 4,
          ),
          Gap(8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 13.sp,
                color: theme.dividerColor,
              ),
              Gap(4.w),
              Expanded(
                child: BText(
                  text: exampleTextKey,
                  fontSize: 11.sp,
                  color: theme.dividerColor,
                  isLocalized: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
