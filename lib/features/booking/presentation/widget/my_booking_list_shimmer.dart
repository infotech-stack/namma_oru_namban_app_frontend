// lib/features/booking/presentation/screen/my_booking_list_shimmer.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/utils/commons/shimmer/b_shimmer_container.dart';
import 'package:userapp/utils/commons/shimmer/b_shimmer_widget.dart';

class MyBookingListShimmer extends StatelessWidget {
  const MyBookingListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return BShimmerWidget(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(children: List.generate(4, (i) => _BookingCardShimmer())),
      ),
    );
  }
}

class _BookingCardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Booking ID header ─────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 9.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Center(
              child: BShimmerContainer(width: 140, height: 11, borderRadius: 6),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Vehicle + Status ──────────────────────────────
                Row(
                  children: [
                    BShimmerContainer(width: 40, height: 40, borderRadius: 10),
                    Gap(10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BShimmerContainer(
                            width: 120,
                            height: 13,
                            borderRadius: 6,
                          ),
                          Gap(6.h),
                          BShimmerContainer(
                            width: 80,
                            height: 11,
                            borderRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    BShimmerContainer(width: 64, height: 22, borderRadius: 20),
                  ],
                ),

                Gap(10.h),

                // ── Route box ────────────────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      // Dot + line + dot
                      Column(
                        children: [
                          BShimmerContainer.circular(size: 8),
                          Container(
                            width: 1.w,
                            height: 16.h,
                            color: Colors.grey.shade300,
                          ),
                          BShimmerContainer.circular(size: 8),
                        ],
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BShimmerContainer(
                              width: 160,
                              height: 11,
                              borderRadius: 6,
                            ),
                            Gap(8.h),
                            BShimmerContainer(
                              width: 130,
                              height: 11,
                              borderRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(10.h),

                // ── Date + Amount ─────────────────────────────────
                Row(
                  children: [
                    BShimmerContainer(width: 12, height: 12, borderRadius: 4),
                    Gap(4.w),
                    BShimmerContainer(width: 110, height: 11, borderRadius: 6),
                    const Spacer(),
                    BShimmerContainer(width: 60, height: 15, borderRadius: 6),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
