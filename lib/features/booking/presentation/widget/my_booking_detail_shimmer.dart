import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/utils/commons/shimmer/b_shimmer_container.dart';
import 'package:userapp/utils/commons/shimmer/b_shimmer_widget.dart';

class MyBookingDetailShimmer extends StatelessWidget {
  const MyBookingDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return BShimmerWidget(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(children: [_stepperShimmer(), Gap(14.h), _cardShimmer()]),
      ),
    );
  }

  Widget _stepperShimmer() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BShimmerContainer(width: 70, height: 10, borderRadius: 6),
          Gap(14.h),
          Row(
            children: List.generate(7, (i) {
              if (i.isOdd) {
                return Expanded(
                  child: Container(height: 2, color: Colors.grey.shade200),
                );
              }
              return Column(
                children: [
                  BShimmerContainer.circular(size: 26),
                  Gap(5.h),
                  BShimmerContainer(width: 48, height: 8, borderRadius: 4),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _cardShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Center(
              child: BShimmerContainer(width: 160, height: 12, borderRadius: 6),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section title
                BShimmerContainer(width: 100, height: 13, borderRadius: 6),
                Gap(12.h),
                // Driver row
                Row(
                  children: [
                    BShimmerContainer(width: 48, height: 48, borderRadius: 12),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BShimmerContainer(
                          width: 130,
                          height: 14,
                          borderRadius: 6,
                        ),
                        Gap(4.h),
                        BShimmerContainer(
                          width: 90,
                          height: 12,
                          borderRadius: 6,
                        ),
                        Gap(6.h),
                        BShimmerContainer(
                          width: 70,
                          height: 22,
                          borderRadius: 6,
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(14.h),
                Divider(color: Colors.grey.shade200, height: 1),
                Gap(12.h),
                // Trip section title
                BShimmerContainer(width: 80, height: 13, borderRadius: 6),
                Gap(12.h),
                // Pickup
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        BShimmerContainer.circular(size: 14),
                        Container(
                          width: 1.5.w,
                          height: 38.h,
                          color: Colors.grey.shade200,
                        ),
                      ],
                    ),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BShimmerContainer(
                          width: 40,
                          height: 10,
                          borderRadius: 4,
                        ),
                        Gap(4.h),
                        BShimmerContainer(
                          width: 200,
                          height: 12,
                          borderRadius: 6,
                        ),
                      ],
                    ),
                  ],
                ),
                // Drop
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BShimmerContainer.circular(size: 14),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BShimmerContainer(
                          width: 40,
                          height: 10,
                          borderRadius: 4,
                        ),
                        Gap(4.h),
                        BShimmerContainer(
                          width: 180,
                          height: 12,
                          borderRadius: 6,
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(14.h),
                // Info boxes
                Row(
                  children: [
                    Expanded(child: _infoBoxShimmer()),
                    Gap(8.w),
                    Expanded(child: _infoBoxShimmer()),
                    Gap(8.w),
                    Expanded(child: _infoBoxShimmer()),
                  ],
                ),
                Gap(14.h),
                Divider(color: Colors.grey.shade200, height: 1),
                Gap(12.h),
                // Payment section
                BShimmerContainer(width: 70, height: 13, borderRadius: 6),
                Gap(10.h),
                Row(
                  children: [
                    BShimmerContainer(width: 38, height: 38, borderRadius: 10),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BShimmerContainer(
                          width: 100,
                          height: 12,
                          borderRadius: 6,
                        ),
                        Gap(4.h),
                        BShimmerContainer(
                          width: 70,
                          height: 10,
                          borderRadius: 6,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BShimmerContainer(
                          width: 30,
                          height: 10,
                          borderRadius: 4,
                        ),
                        Gap(4.h),
                        BShimmerContainer(
                          width: 60,
                          height: 15,
                          borderRadius: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBoxShimmer() => Container(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Column(
      children: [
        BShimmerContainer(width: 30, height: 10, borderRadius: 4),
        Gap(4.h),
        BShimmerContainer(width: 50, height: 13, borderRadius: 6),
      ],
    ),
  );
}
