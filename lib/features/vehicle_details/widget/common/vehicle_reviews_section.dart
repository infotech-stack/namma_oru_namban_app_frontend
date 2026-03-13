// lib/features/vehicle_details/presentation/widgets/common/vehicle_reviews_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class VehicleReviewsSection extends StatelessWidget {
  final List<ReviewData> reviews;
  final String vehicleType; // for logging if needed

  const VehicleReviewsSection({
    super.key,
    required this.reviews,
    required this.vehicleType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleReviews = reviews.take(2).toList();
    final hasMore = reviews.length > 2;
    final avg =
        reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    size: 16.sp,
                    color: const Color(0xFFFFB300),
                  ),
                ),
                Gap(10.w),
                BText(
                  text: 'reviews',
                  fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
                  fontWeight: FontWeight.w700,
                  isLocalized: true,
                ),
              ],
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB300).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color(0xFFFFB300).withValues(alpha: 0.30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 12.sp,
                    color: const Color(0xFFFFB300),
                  ),
                  Gap(3.w),
                  Text(
                    avg.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFFB300),
                    ),
                  ),
                  Text(
                    ' (${reviews.length})',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: theme.dividerColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Gap(14.h),

        ...visibleReviews.map(
          (r) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _buildReviewCard(theme, r),
          ),
        ),

        if (hasMore) ...[
          Gap(2.h),
          GestureDetector(
            onTap: () => _openAllReviewsSheet(context, theme),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.35),
                ),
                borderRadius: BorderRadius.circular(14.r),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.06),
                    theme.colorScheme.primary.withValues(alpha: 0.02),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${'view_all'.tr} ${reviews.length} ${'reviews'.tr}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Gap(6.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.sp,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _openAllReviewsSheet(BuildContext context, ThemeData theme) {
    final avg =
        reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            Gap(16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BText(
                      text: 'reviews',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      isLocalized: true,
                    ),
                    Gap(2.h),
                    Text(
                      '${reviews.length} ${'reviews'.tr}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: theme.dividerColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: const Color(0xFFFFB300).withValues(alpha: 0.30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 18.sp,
                        color: const Color(0xFFFFB300),
                      ),
                      Gap(5.w),
                      Text(
                        avg.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFB300),
                        ),
                      ),
                      Text(
                        ' / 5',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.dividerColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(16.h),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: Get.height * 0.55),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: reviews.length,
                separatorBuilder: (_, __) => Gap(10.h),
                itemBuilder: (_, i) => _buildReviewCard(theme, reviews[i]),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildReviewCard(ThemeData theme, ReviewData review) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.70),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.avatar,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      review.date,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: theme.dividerColor,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 13.sp,
                    color: i < review.rating
                        ? const Color(0xFFFFB300)
                        : theme.dividerColor.withValues(alpha: 0.40),
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.80),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewData {
  final String name;
  final String avatar;
  final int rating;
  final String comment;
  final String date;

  ReviewData({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
