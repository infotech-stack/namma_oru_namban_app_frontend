// lib/features/booking/presentation/widgets/common/booking_confirm_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:userapp/utils/commons/button/b_button.dart';

class BookingConfirmButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const BookingConfirmButton({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BButton(
        text: 'confirm_booking',
        onTap: onConfirm,
        isOutline: false,
      ),
    );
  }
}
