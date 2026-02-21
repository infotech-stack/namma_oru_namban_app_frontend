import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import '../controller/vehicle_detailse_controller.dart';

class VehicleDetailScreen extends GetView<VehicleDetailController> {
  const VehicleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.secondary,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ✅ Header stays on top — scroll content goes BEHIND it
            SliverPersistentHeader(
              pinned: true,
              delegate: _TopSectionDelegate(
                child: _buildTopSection(theme),
                maxHeight: 235.h, // ✅ full height of purple + overlapping image
              ),
            ),

            // ✅ Scrollable content — slides under the header
            SliverPadding(
              padding: EdgeInsets.only(
                top: 90.h, // ✅ normal gap
                left: 16.w,
                right: 16.w,
                bottom: 20.h,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatsRow(theme),
                  Gap(20.h),
                  _buildSpecifications(theme),
                  Gap(20.h),
                ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBookButton(theme),
      ),
    );
  }

  // ── Purple Header ──────────────────────────────────────────────────────────

  Widget _buildTopSection(ThemeData theme) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Purple background ──
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.r),
              bottomRight: Radius.circular(25.r),
            ),
          ),
          padding: EdgeInsets.only(
            top: 30.h,
            left: 16.w,
            right: 16.w,
            bottom: 80.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + Fare
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(
                          alpha: 0.15,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.secondary,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      controller.fare,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(14.h),

              // Name + Rating
              Row(
                children: [
                  Text(
                    controller.name,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  Gap(8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 13.sp,
                        ),
                        Gap(3.w),
                        Text(
                          controller.rating,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(6.h),

              // Subtitle
              Text(
                '${'heavy_duty'.tr} • ${'available_247'.tr} • ${controller.tripsCompleted} ${'trips_completed'.tr}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),

        // ✅ Vehicle image overlapping
        Positioned(
          bottom: -70.h,
          left: 16.w,
          right: 16.w,
          child: Container(
            height: 160.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: controller.imagePath != null
                  ? Image.asset(controller.imagePath!, fit: BoxFit.cover)
                  : Icon(
                      Icons.local_shipping_rounded,
                      size: 60.sp,
                      color: theme.colorScheme.primary,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────────────────

  Widget _buildStatsRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            theme,
            Icons.inventory_2_outlined,
            'capacity',
            '${controller.capacity} ${'ton'.tr}',
          ),
        ),
        Gap(10.w),
        Expanded(
          child: _statCard(
            theme,
            Icons.access_time_rounded,
            'eta',
            '${controller.eta} ${'mins'.tr}',
          ),
        ),
        Gap(10.w),
        Expanded(
          child: _statCard(
            theme,
            Icons.location_on_outlined,
            'distance',
            '${controller.distance} ${'km'.tr}',
            iconColor: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    ThemeData theme,
    IconData icon,
    String labelKey,
    String value, {
    Color? iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: iconColor ?? theme.colorScheme.primary,
          ),
          Gap(6.h),
          BText(
            text: labelKey,
            fontSize: 10.sp,
            color: theme.dividerColor,
            isLocalized: true,
          ),
          Gap(3.h),
          BText(
            text: value,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            isLocalized: false,
          ),
        ],
      ),
    );
  }

  // ── Specifications ─────────────────────────────────────────────────────────

  Widget _buildSpecifications(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BText(
            text: 'vehicle_specifications',
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            isLocalized: true,
          ),
          Gap(14.h),
          Obx(
            () => Column(
              children: controller.specs
                  .map(
                    (spec) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110.w,
                            child: BText(
                              text: spec['label']!,
                              fontSize: 12.sp,
                              color: theme.colorScheme.primary,
                              isLocalized: true,
                            ),
                          ),
                          Expanded(
                            child: BText(
                              text: spec['value']!,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              isLocalized: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Book Button ────────────────────────────────────────────────────────────

  Widget _buildBookButton(ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        bottom: 20.h,
        top: 12.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BButton(
        text: 'book_now',
        isLocalized: true,
        textColor: theme.secondaryHeaderColor,
        onTap: controller.onBookNow,
        suffixIcon: Icon(
          Icons.arrow_forward,
          color: theme.secondaryHeaderColor,
        ),
      ),
    );
  }
}

// ── Delegate to pin _buildTopSection as a persistent header ────────────────

class _TopSectionDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;

  _TopSectionDelegate({required this.child, required this.maxHeight});

  @override
  double get minExtent => maxHeight; // ✅ pinned — never shrinks

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_TopSectionDelegate oldDelegate) => false;
}
