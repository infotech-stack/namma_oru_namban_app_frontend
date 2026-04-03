// lib/features/vehicle_details/presentation/widgets/common/vehicle_reviews_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class VehicleReviewsSection extends StatelessWidget {
  final List<ReviewData> reviews;
  final String vehicleType;

  const VehicleReviewsSection({
    super.key,
    required this.reviews,
    required this.vehicleType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (reviews.isEmpty) return const SizedBox();

    final visibleReviews = reviews.take(2).toList();
    final hasMore = reviews.length > 2;
    final avg =
        reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 HEADER (UPGRADED)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB300).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 18.sp,
                      color: const Color(0xFFFFB300),
                    ),
                  ),
                  Gap(10.w),
                  BText(
                    text: 'reviews',
                    fontSize: responsiveFont(en: 15.sp, ta: 13.sp),
                    fontWeight: FontWeight.w700,
                    isLocalized: true,
                  ),
                ],
              ),

              /// ⭐ AVG
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFFB300),
                    ),
                  ),
                  Text(
                    '${reviews.length} reviews',
                    style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          Gap(12.h),

          /// 🔥 MINI SUMMARY BAR (NEW 🔥)
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: avg / 5,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFFB300)),
            ),
          ),

          Gap(14.h),

          /// 🔥 REVIEW CARDS
          ...visibleReviews.map(
            (r) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildReviewCard(theme, r),
            ),
          ),

          /// 🔥 VIEW ALL BUTTON
          if (hasMore)
            GestureDetector(
              onTap: () => _openAllReviewsSheet(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${'view_all'.tr} ${reviews.length} ${'reviews'.tr}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 🔥 MODERN REVIEW CARD
  Widget _buildReviewCard(ThemeData theme, ReviewData review) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              /// 👤 AVATAR
              CircleAvatar(
                radius: 18.r,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                child: Text(
                  review.avatar,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              Gap(10.w),

              /// NAME + DATE
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
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              /// ⭐ RATING
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 14.sp,
                    color: const Color(0xFFFFB300),
                  ),
                ),
              ),
            ],
          ),

          Gap(10.h),

          /// 💬 COMMENT
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 FULL SCREEN BOTTOM SHEET (REAL APP STYLE)
  void _openAllReviewsSheet(BuildContext context) {
    final theme = Theme.of(context);

    final avg =
        reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    Get.to(
      () => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              /// 🔝 HEADER
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'reviews'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              /// 🔥 ADD HERE 👇 (Rating Summary Block)
              Container(
                padding: EdgeInsets.all(14.r),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    /// ⭐ AVG
                    Column(
                      children: [
                        Text(
                          avg.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star_rounded,
                              size: 14.sp,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Gap(16.w),

                    /// 📊 BARS
                    Expanded(
                      child: Column(
                        children: List.generate(5, (i) {
                          int star = 5 - i;

                          int count = reviews
                              .where((r) => r.rating == star)
                              .length;

                          double percent = count / reviews.length;

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Row(
                              children: [
                                Text(
                                  '$star',
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                                Gap(4.w),
                                Icon(
                                  Icons.star,
                                  size: 10.sp,
                                  color: Colors.amber,
                                ),
                                Gap(6.w),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: LinearProgressIndicator(
                                      value: percent,
                                      minHeight: 6,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: const AlwaysStoppedAnimation(
                                        Colors.amber,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(12.h),

              /// 🔥 LIST (keep this below)
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => Gap(12.h),
                  itemBuilder: (_, i) => _buildReviewCard(theme, reviews[i]),
                ),
              ),
            ],
          ),
        ),
      ),
      transition: Transition.downToUp, // 👈 comes from top
      duration: const Duration(milliseconds: 300),
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
