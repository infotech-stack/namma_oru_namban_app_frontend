// lib/features/vehicle_details/unified/screens/unified_vehicle_detail_screen.dart
// ════════════════════════════════════════════════════════════════
//  UNIFIED VEHICLE DETAIL SCREEN — Fixed null safety
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/presentation/controller/unified_vehicle_detail_controller.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_hero_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_reviews_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_similar_list.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_specs_container.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_stats_row.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class UnifiedVehicleDetailScreen
    extends GetView<UnifiedVehicleDetailController> {
  const UnifiedVehicleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.secondary,
        bottomNavigationBar: _buildBookButton(theme),
        body: Obx(() {
          // ✅ First check if loading
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Then check for error
          if (controller.errorMessage.value.isNotEmpty) {
            return _buildErrorState(theme);
          }

          // ✅ Finally check if vehicle is null
          if (controller.vehicle.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Now safe to access vehicle data
          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: VehicleHeroSection(
                  vehicleName: controller.name,
                  rating: controller.rating,
                  fare: controller.fare,
                  fareUnit: controller.fareUnit,
                  subtitle: _getSubtitle(),
                  tripsCompleted: controller.tripsCompleted,
                  vehicleImages: controller.images.whereType<String>().toList(),
                  onBack: () => Get.back(),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: VehicleStatsRow(stats: controller.stats),
                              ),
                            ),
                            Gap(24.h),
                            // ✅ Safe availability badge
                            _buildAvailabilityBadge(theme),
                            Gap(24.h),
                            VehicleSpecsContainer(
                              titleKey: _getSpecsTitleKey(),
                              headerIcon: Icons.tune_rounded,
                              specs: controller.specs,
                            ),
                            Gap(20.h),
                            _buildTypeSpecificSections(theme),
                            Gap(20.h),
                            if (controller.vehicle.value?.description != null &&
                                controller
                                    .vehicle
                                    .value!
                                    .description!
                                    .isNotEmpty)
                              _buildDescriptionCard(theme),
                            Obx(() {
                              if (controller.isLoadingReviews.value) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return VehicleReviewsSection(
                                reviews: controller.reviewList,
                                vehicleType:
                                    controller.vehicle.value?.categorySlug ??
                                    'car',
                              );
                            }),
                            Gap(20.h),
                            if (controller.similarVehicles.isNotEmpty)
                              _buildSimilarVehiclesSection(theme),
                            Gap(30.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ✅ Fixed availability badge - no Obx wrapper needed inside
  Widget _buildAvailabilityBadge(ThemeData theme) {
    // Check if vehicle exists first
    if (controller.vehicle.value == null) {
      return const SizedBox.shrink();
    }

    final canBook = controller.vehicle.value?.canBook ?? false;
    final isBusy = controller.vehicle.value?.isDriverBusy ?? false;
    final busyReason =
        controller.vehicle.value?.busyReason ??
        'Driver is currently busy with another booking';
    final isAvailable = controller.vehicle.value?.isAvailable ?? true;

    // Available — show green badge
    if (canBook && !isBusy && isAvailable) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFD1FAE5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF059669).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: const BoxDecoration(
                color: Color(0xFF059669),
                shape: BoxShape.circle,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: BText(
                text: 'driver_available',
                isLocalized: true,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    // Vehicle not available (maintenance etc)
    if (!isAvailable) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFEF4444).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.car_crash, size: 18.sp, color: const Color(0xFFB91C1C)),
            Gap(10.w),
            Expanded(
              child: Text(
                'Vehicle currently unavailable for booking',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF991B1B),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Busy — show red/orange badge with reason
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 18.sp,
            color: const Color(0xFF92400E),
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'driver_busy_title'.tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF92400E),
                  ),
                ),
                Gap(4.h),
                Text(
                  busyReason,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF92400E).withValues(alpha: 0.8),
                  ),
                ),
                Gap(8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 12.sp,
                        color: const Color(0xFF92400E),
                      ),
                      Gap(4.w),
                      Text(
                        'Try another vehicle or check back later',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.secondary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48.sp,
                  color: Colors.grey[400],
                ),
              ),
              Gap(24.h),
              BText(
                text: controller.errorMessage.value,
                fontSize: 14.sp,
                color: Colors.grey[600]!,
                isLocalized: false,
                textAlign: TextAlign.center,
              ),
              Gap(24.h),
              BButton(
                text: 'retry',
                onTap: controller.fetchVehicleDetail,
                width: 150.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(ThemeData theme) {
    return _ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF7C4DFF).withValues(alpha: 0.1),
                      const Color(0xFF7C4DFF).withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.description_rounded,
                  size: 22.sp,
                  color: const Color(0xFF7C4DFF),
                ),
              ),
              Gap(12.w),
              Expanded(
                child: BText(
                  text: 'description'.tr,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  isLocalized: false,
                ),
              ),
            ],
          ),
          Gap(16.h),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText(
                  text: controller.vehicle.value?.description ?? '',
                  fontSize: 13.sp,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  isLocalized: false,
                  maxLines: controller.isReadMore.value ? null : 3,
                ),
                if ((controller.vehicle.value?.description?.length ?? 0) > 150)
                  GestureDetector(
                    onTap: controller.toggleReadMore,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BText(
                            text: controller.isReadMore.value
                                ? 'read_less'
                                : 'read_more',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                            isLocalized: true,
                          ),
                          Gap(4.w),
                          Icon(
                            controller.isReadMore.value
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 18.sp,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarVehiclesSection(ThemeData theme) {
    return VehicleSimilarList(
      titleKey: _getSimilarTitleKey(),
      defaultIcon: _getVehicleIcon(),
      vehicles: controller.similarVehicles,
      onItemTap: (SimilarVehicleItem vehicle) {
        controller.onSimilarVehicleTap(vehicle);
      },
    );
  }

  Widget _buildTypeSpecificSections(ThemeData theme) {
    final type = controller.vehicle.value?.categorySlug ?? 'car';

    switch (type) {
      case 'bus':
      case 'mini_bus':
        return Column(
          children: [
            _ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    theme,
                    icon: Icons.star_rounded,
                    iconColor: const Color(0xFFD4A96A),
                    title: 'bus_amenities',
                  ),
                  Gap(16.h),
                  Obx(() => _buildTagWrap(theme, controller.amenities)),
                ],
              ),
            ),
            Gap(16.h),
          ],
        );

      case 'agri_equipment':
        return Column(
          children: [
            _ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    theme,
                    icon: Icons.access_time_rounded,
                    iconColor: const Color(0xFF5C6BC0),
                    title: 'agri_availability',
                  ),
                  Gap(16.h),
                  Obx(
                    () => Column(
                      children: [
                        _buildAvailabilityRow(
                          theme,
                          'available_from',
                          controller.availableFrom,
                        ),
                        _buildAvailabilityRow(
                          theme,
                          'available_to',
                          controller.availableTo,
                        ),
                        _buildAvailabilityRow(
                          theme,
                          'min_booking',
                          controller.minBookingHours,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(16.h),
            Obx(() {
              if (controller.suitableFor.isEmpty)
                return const SizedBox.shrink();
              return _ModernCard(
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF43A047).withValues(alpha: 0.08),
                        const Color(0xFF43A047).withValues(alpha: 0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF43A047,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 18.sp,
                              color: const Color(0xFF43A047),
                            ),
                          ),
                          Gap(10.w),
                          Expanded(
                            child: Text(
                              'agri_suitable_for'.tr,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(14.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: controller.suitableFor.map((item) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                color: const Color(
                                  0xFF43A047,
                                ).withValues(alpha: 0.25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.eco_rounded,
                                  size: 14.sp,
                                  color: const Color(0xFF43A047),
                                ),
                                Gap(6.w),
                                Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Gap(16.h),
          ],
        );

      case 'jcb':
        return Column(
          children: [
            _ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    theme,
                    icon: Icons.location_on_rounded,
                    iconColor: const Color(0xFFFF7043),
                    title: 'jcb_working_areas',
                  ),
                  Gap(16.h),
                  Obx(
                    () => _buildTagWrap(
                      theme,
                      controller.workingAreas,
                      isLocalized: false,
                    ),
                  ),
                ],
              ),
            ),
            Gap(16.h),
          ],
        );

      case 'tractor':
        return Obx(() {
          final attachmentValue = controller.attachment;
          final hasAttachment =
              attachmentValue.isNotEmpty &&
              attachmentValue != 'N/A' &&
              attachmentValue != 'null';

          if (!hasAttachment) return const SizedBox.shrink();

          return Column(
            children: [
              _ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      theme,
                      icon: Icons.build_circle_rounded,
                      iconColor: const Color(0xFF43A047),
                      title: 'tractor_attachments',
                    ),
                    Gap(16.h),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.agriculture_rounded,
                              size: 24.sp,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: BText(
                              text: attachmentValue,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              isLocalized: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Gap(16.h),
            ],
          );
        });

      case 'heavy_lorry':
        return Column(
          children: [
            _ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    theme,
                    icon: Icons.inventory_rounded,
                    iconColor: const Color(0xFF7C4DFF),
                    title: 'lorry_load_types',
                  ),
                  Gap(16.h),
                  Obx(() => _buildTagWrap(theme, controller.loadTypes)),
                ],
              ),
            ),
            Gap(16.h),
          ],
        );

      case 'tata_ace':
        return Column(
          children: [
            _ModernCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    theme,
                    icon: Icons.category_rounded,
                    iconColor: const Color(0xFF7C4DFF),
                    title: 'ace_usage_types',
                  ),
                  Gap(16.h),
                  Obx(() => _buildTagWrap(theme, controller.usageTypes)),
                ],
              ),
            ),
            Gap(16.h),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSectionHeader(
    ThemeData theme, {
    required IconData icon,
    required Color iconColor,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                iconColor.withValues(alpha: 0.1),
                iconColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 22.sp, color: iconColor),
        ),
        Gap(12.w),
        Expanded(
          child: BText(
            text: title.tr,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            isLocalized: false,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityRow(
    ThemeData theme,
    String labelKey,
    String value, {
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 16.sp,
            color: theme.colorScheme.primary,
          ),
          Gap(12.w),
          Expanded(
            child: BText(
              text: labelKey.tr,
              fontSize: 13.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              isLocalized: false,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: BText(
              text: value,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
              isLocalized: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagWrap(
    ThemeData theme,
    List<String> tags, {
    bool isLocalized = true,
  }) {
    if (tags.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: BText(
          text: 'no_information'.tr,
          fontSize: 13.sp,
          color: Colors.grey[500],
          isLocalized: false,
        ),
      );
    }
    return Wrap(
      runSpacing: 8.h,
      spacing: 8.w,
      children: tags
          .map((item) => _buildModernTag(theme, item, isLocalized: isLocalized))
          .toList(),
    );
  }

  Widget _buildModernTag(
    ThemeData theme,
    String label, {
    bool isLocalized = true,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.08),
            theme.colorScheme.primary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14.sp,
            color: theme.colorScheme.primary,
          ),
          Gap(6.w),
          BText(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary,
            isLocalized: isLocalized,
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(ThemeData theme) {
    return Obx(() {
      // Check if vehicle exists and can book
      final canBook = controller.vehicle.value?.canBook ?? false;
      final isDriverBusy = controller.vehicle.value?.isDriverBusy ?? false;
      final isAvailable = controller.vehicle.value?.isAvailable ?? true;

      final isButtonEnabled = canBook && isAvailable && !isDriverBusy;

      return Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: BButton(
            text: isButtonEnabled ? 'book_now' : 'currently_unavailable',
            onTap: isButtonEnabled ? controller.onBookNow : () {},
            suffixIcon: Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
            backgroundColor: isButtonEnabled
                ? theme.primaryColor
                : theme.primaryColor.withValues(alpha: 0.5),
          ),
        ),
      );
    });
  }

  String _getSubtitle() {
    final type = controller.vehicle.value?.categorySlug ?? 'car';
    switch (type) {
      case 'car':
        return 'ac_car'.tr;
      case 'bus':
      case 'mini_bus':
        return controller.busCategory.tr;
      case 'agri_equipment':
        return controller.equipmentType.tr;
      case 'jcb':
        return 'jcb'.tr;
      case 'heavy_lorry':
        return 'heavy_lorry'.tr;
      case 'tata_ace':
        return 'tata_ace'.tr;
      case 'tractor':
        return 'tractor'.tr;
      default:
        return 'vehicle'.tr;
    }
  }

  String _getSpecsTitleKey() {
    final type = controller.vehicle.value?.categorySlug ?? 'car';
    switch (type) {
      case 'car':
        return 'car_specifications';
      case 'bus':
      case 'mini_bus':
        return 'bus_specifications';
      case 'agri_equipment':
        return 'agri_specifications';
      case 'jcb':
        return 'jcb_specifications';
      case 'heavy_lorry':
        return 'lorry_specifications';
      case 'tata_ace':
        return 'ace_specifications';
      case 'tractor':
        return 'tractor_specifications';
      default:
        return 'specifications';
    }
  }

  String _getSimilarTitleKey() {
    final type = controller.vehicle.value?.categorySlug ?? 'car';
    switch (type) {
      case 'car':
        return 'similar_cars';
      case 'bus':
      case 'mini_bus':
        return 'similar_buses';
      case 'agri_equipment':
        return 'similar_equipment';
      case 'jcb':
        return 'similar_jcb';
      case 'heavy_lorry':
        return 'similar_lorries';
      case 'tata_ace':
        return 'similar_ace';
      case 'tractor':
        return 'similar_tractors';
      default:
        return 'similar_vehicles';
    }
  }

  IconData _getVehicleIcon() {
    final type = controller.vehicle.value?.categorySlug ?? 'car';
    switch (type) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'bus':
      case 'mini_bus':
        return Icons.directions_bus_rounded;
      case 'jcb':
        return Icons.construction_rounded;
      case 'heavy_lorry':
      case 'tata_ace':
        return Icons.local_shipping_rounded;
      case 'tractor':
        return Icons.agriculture_rounded;
      case 'agri_equipment':
        return Icons.grass_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }
}

class _ModernCard extends StatelessWidget {
  const _ModernCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(padding: EdgeInsets.all(16.w), child: child),
    );
  }
}
