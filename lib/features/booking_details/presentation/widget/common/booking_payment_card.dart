// lib/features/booking/presentation/widgets/common/booking_payment_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';

class BookingPaymentCard extends StatelessWidget {
  final List<PaymentOption> options;
  final String selectedPayment;
  final Function(String) onPaymentSelected;

  const BookingPaymentCard({
    super.key,
    required this.options,
    required this.selectedPayment,
    required this.onPaymentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BookingCardDecoration(theme: theme),
      child: Column(
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedPayment == option.type;
          final isLast = index == options.length - 1;

          return Column(
            children: [
              GestureDetector(
                onTap: () => onPaymentSelected(option.type),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      Gap(12.w),
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          option.icon,
                          size: 16.sp,
                          color: theme.dividerColor,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Text(
                          option.label,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Divider(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                    height: 1,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class PaymentOption {
  final String type;
  final String label;
  final IconData icon;

  PaymentOption({required this.type, required this.label, required this.icon});
}
