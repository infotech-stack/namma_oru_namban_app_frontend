// lib/features/booking/presentation/widgets/common/booking_card_decoration.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingCardDecoration extends BoxDecoration {
  BookingCardDecoration({required ThemeData theme, double borderRadius = 14})
    : super(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      );
}
