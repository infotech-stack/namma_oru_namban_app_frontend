// lib/features/booking/presentation/widgets/common/booking_promo_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';

class BookingPromoCard extends StatelessWidget {
  final TextEditingController controller;
  final bool promoApplied;
  final String promoMessage;
  final VoidCallback onApply;

  const BookingPromoCard({
    super.key,
    required this.controller,
    required this.promoApplied,
    required this.promoMessage,
    required this.onApply,
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
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    style: TextStyle(
                      fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      filled: false,
                      fillColor: Colors.transparent,
                      hintText: 'enter_promo_hint'.tr,
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: theme.dividerColor,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 1,
                        ),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                  ),
                ),
              ),
              Gap(10.w),
              GestureDetector(
                onTap: onApply,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: BText(
                      text: 'apply',
                      fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.secondary,
                      isLocalized: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (promoApplied && promoMessage.isNotEmpty) ...[
            Gap(10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppTheme.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppTheme.green.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                promoMessage,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.greenDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
