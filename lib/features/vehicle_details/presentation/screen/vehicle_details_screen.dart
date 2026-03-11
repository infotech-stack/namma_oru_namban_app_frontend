// lib/features/vehicle_details/presentation/screens/vehicle_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/features/vehicle_details/presentation/controller/vehicle_detailse_controller.dart';
import 'package:userapp/features/vehicle_details/presentation/widget/vehicle_carousal_image_widget.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class VehicleDetailScreen extends GetView<VehicleDetailController> {
  VehicleDetailScreen({super.key});

  final langController = Get.find<LanguageController>();

  final _reviews = const [
    _ReviewData(
      name: 'Arun Kumar',
      avatar: 'AK',
      rating: 5,
      comment:
          'Excellent service! Vehicle was clean and driver was very professional.',
      date: '2 days ago',
    ),
    _ReviewData(
      name: 'Priya S',
      avatar: 'PS',
      rating: 4,
      comment: 'Good experience overall. Arrived on time and safe delivery.',
      date: '1 week ago',
    ),
    _ReviewData(
      name: 'Rajan M',
      avatar: 'RM',
      rating: 5,
      comment: 'Best service in town! Will definitely book again.',
      date: '2 weeks ago',
    ),
    _ReviewData(
      name: 'Divya K',
      avatar: 'DK',
      rating: 4,
      comment: 'Smooth experience. Driver was helpful and polite.',
      date: '3 weeks ago',
    ),
    _ReviewData(
      name: 'Suresh P',
      avatar: 'SP',
      rating: 3,
      comment: 'Average service. Vehicle was okay but slightly delayed.',
      date: '1 month ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: theme.colorScheme.secondary,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: theme.colorScheme.secondary,
          // ── Book Now pinned bottom ───────────────────────────
          bottomNavigationBar: _buildBookButton(theme),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── HERO — purple gradient section with carousel ─
              SliverToBoxAdapter(child: _buildHeroSection(theme)),

              // ── SCROLLABLE CONTENT ───────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStatsRow(theme),
                    Gap(24.h),
                    _buildGradientDivider(theme),
                    Gap(24.h),
                    _buildSpecifications(theme),
                    Gap(24.h),
                    _buildReviewsSection(theme, context),
                    Gap(24.h),
                    _buildSimilarVehicles(theme),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  HERO SECTION — purple gradient + carousel (no Stack)
  // ════════════════════════════════════════════════════════════
  // ════════════════════════════════════════════════════════════════
  //  _buildHeroSection — UPDATED
  //  ✅ No primary color background
  //  ✅ Order: topbar → name → subtitle → carousel
  //  ✅ Carousel full width fit
  // ════════════════════════════════════════════════════════════════

  Widget _buildHeroSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Top bar: back + lang + fare ──────────────────────
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.20,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: theme.colorScheme.primary,
                      size: 16.sp,
                    ),
                  ),
                ),

                // Lang + fare
                Row(
                  children: [
                    Obx(
                      () => GestureDetector(
                        onTap: () => langController.toggleLanguage(),
                        child: Container(
                          width: 38.r,
                          height: 38.r,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.10,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.20,
                              ),
                            ),
                          ),
                          child: Icon(
                            langController.currentLocale.value.languageCode ==
                                    'en'
                                ? Icons.language
                                : Icons.translate,
                            color: theme.colorScheme.primary,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                    Gap(10.w),

                    // Fare pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.82),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.30,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.fare,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'km',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Gap(16.h),

        // ── 2. Name + Rating ────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  controller.name,
                  style: TextStyle(
                    fontSize: responsiveFont(en: 18.sp, ta: 18.sp),
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                    height: 1.1,
                  ),
                ),
              ),
              Gap(10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF43A047).withValues(alpha: 0.30),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 12.sp),
                    Gap(4.w),
                    Text(
                      controller.rating,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(6.h),

        // ── 3. Subtitle ─────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Icon(
                Icons.verified_rounded,
                size: 13.sp,
                color: theme.colorScheme.primary,
              ),
              Gap(4.w),
              Expanded(
                child: Text(
                  '${'heavy_duty'.tr} • ${'available_247'.tr} • ${controller.tripsCompleted} ${'trips_completed'.tr}',
                  style: TextStyle(fontSize: 11.sp, color: theme.dividerColor),
                ),
              ),
            ],
          ),
        ),
        Gap(16.h),

        // ── 4. Carousel — full width, no horizontal padding ─────
        VehicleImageCarousel(
          // images: [controller.imagePath],
          images: controller.vehicleImages,
          height: 220,
          autoScrollDuration: Duration(seconds: 3), // default
          animationDuration: Duration(milliseconds: 500), // default
          // fullWidth: true → no side margins in carousel widget
        ),

        Gap(8.h),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  //  STATS ROW
  // ════════════════════════════════════════════════════════════
  Widget _buildStatsRow(ThemeData theme) {
    final p = theme.colorScheme.primary;
    final stats = [
      {
        'icon': Icons.inventory_2_outlined,
        'label': 'capacity',
        'value': controller.capacity,
        'color': p,
      },
      {
        'icon': Icons.access_time_rounded,
        'label': 'eta',
        'value': '${controller.eta} min',
        'color': const Color(0xFF1E88E5),
      },
      {
        'icon': Icons.location_on_outlined,
        'label': 'distance',
        'value': '${controller.distance} km',
        'color': const Color(0xFFE53935),
      },
    ];

    return Row(
      children: stats.asMap().entries.map((e) {
        final i = e.key;
        final stat = e.value;
        final color = stat['color'] as Color;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 10.w : 0),
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.12),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: color.withValues(alpha: 0.20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    stat['icon'] as IconData,
                    size: 16.sp,
                    color: color,
                  ),
                ),
                Gap(7.h),
                BText(
                  text: stat['label'] as String,
                  fontSize: responsiveFont(en: 9.sp, ta: 8.sp),
                  color: theme.dividerColor,
                  isLocalized: true,
                ),
                Gap(3.h),
                BText(
                  text: stat['value'] as String,
                  fontSize: responsiveFont(en: 11.sp, ta: 9.sp),
                  fontWeight: FontWeight.w700,
                  isLocalized: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGradientDivider(ThemeData theme) {
    return Container(
      height: 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            theme.colorScheme.primary.withValues(alpha: 0.35),
            theme.colorScheme.primary.withValues(alpha: 0.35),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  SPECIFICATIONS
  // ════════════════════════════════════════════════════════════
  Widget _buildSpecifications(ThemeData theme) {
    final p = theme.colorScheme.primary;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p.withValues(alpha: 0.08), p.withValues(alpha: 0.03)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: p.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.r),
                decoration: BoxDecoration(
                  color: p.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.tune_rounded, size: 16.sp, color: p),
              ),
              Gap(10.w),
              BText(
                text: 'vehicle_specifications',
                fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
                fontWeight: FontWeight.w700,
                isLocalized: true,
              ),
            ],
          ),
          Gap(16.h),
          Obx(
            () => Column(
              children: controller.specs
                  .map(
                    (spec) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Row(
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: p,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Gap(10.w),
                          SizedBox(
                            width: 110.w,
                            child: BText(
                              text: spec['label']!,
                              fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                              color: theme.dividerColor,
                              isLocalized: true,
                            ),
                          ),
                          Expanded(
                            child: BText(
                              text: spec['value']!,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
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

  // ════════════════════════════════════════════════════════════
  //  REVIEWS — 2 visible + View All bottomsheet
  // ════════════════════════════════════════════════════════════
  Widget _buildReviewsSection(ThemeData theme, BuildContext context) {
    final visibleReviews = _reviews.take(2).toList();
    final hasMore = _reviews.length > 2;
    final avg =
        _reviews.map((r) => r.rating).reduce((a, b) => a + b) / _reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
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

            // Avg badge
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
                    ' (${_reviews.length})',
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

        // 2 cards
        ...visibleReviews.map(
          (r) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _buildReviewCard(theme, r),
          ),
        ),

        // View All button
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
                    '${'view_all'.tr} ${_reviews.length} ${'reviews'.tr}',
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
        _reviews.map((r) => r.rating).reduce((a, b) => a + b) / _reviews.length;

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
                      '${_reviews.length} ${'reviews'.tr}',
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
                itemCount: _reviews.length,
                separatorBuilder: (_, __) => Gap(10.h),
                itemBuilder: (_, i) => _buildReviewCard(theme, _reviews[i]),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildReviewCard(ThemeData theme, _ReviewData review) {
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

  // ════════════════════════════════════════════════════════════
  //  SIMILAR VEHICLES
  // ════════════════════════════════════════════════════════════
  Widget _buildSimilarVehicles(ThemeData theme) {
    final p = theme.colorScheme.primary;
    final similar = [
      {
        'name': 'Mini Lorry',
        'fare': '₹28/',
        'rating': '4.3',
        'icon': Icons.local_shipping_rounded,
      },
      {
        'name': 'Heavy Truck',
        'fare': '₹45/',
        'rating': '4.1',
        'icon': Icons.fire_truck_rounded,
      },
      {
        'name': 'Pickup Van',
        'fare': '₹20/',
        'rating': '4.5',
        'icon': Icons.airport_shuttle_rounded,
      },
      {
        'name': 'Container',
        'fare': '₹60/',
        'rating': '4.0',
        'icon': Icons.rv_hookup_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                color: p.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.grid_view_rounded, size: 16.sp, color: p),
            ),
            Gap(10.w),
            BText(
              text: 'similar_vehicles',
              fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
              fontWeight: FontWeight.w700,
              isLocalized: true,
            ),
          ],
        ),
        Gap(14.h),
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: similar.length,
            separatorBuilder: (_, __) => Gap(10.w),
            itemBuilder: (_, i) {
              final v = similar[i];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  width: 120.w,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        p.withValues(alpha: 0.10),
                        p.withValues(alpha: 0.04),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: p.withValues(alpha: 0.18)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: p.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          v['icon'] as IconData,
                          size: 20.sp,
                          color: p,
                        ),
                      ),
                      Text(
                        v['name'] as String,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            v['fare'] as String,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: p,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 10.sp,
                                color: const Color(0xFFFFB300),
                              ),
                              Gap(2.w),
                              Text(
                                v['rating'] as String,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  //  BOOK NOW — bottomNavigationBar (no Stack needed)
  // ════════════════════════════════════════════════════════════
  Widget _buildBookButton(ThemeData theme) {
    final p = theme.colorScheme.primary;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BButton(
        text: 'book',
        onTap: controller.onBookNow,
        suffixIcon: Icon(
          Icons.arrow_circle_right_outlined,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  REVIEW DATA MODEL
// ════════════════════════════════════════════════════════════════
class _ReviewData {
  final String name;
  final String avatar;
  final int rating;
  final String comment;
  final String date;

  const _ReviewData({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
