// lib/features/booking/presentation/widgets/common/booking_section_title.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class BookingSectionTitle extends StatelessWidget {
  final String titleKey;

  const BookingSectionTitle({super.key, required this.titleKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BText(
      text: titleKey,
      fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
      isLocalized: true,
    );
  }
}
