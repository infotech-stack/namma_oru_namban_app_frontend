// lib/features/vehicle_details/widget/common/vehicle_similar_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/commons/catch_image/app_catch_image.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class SimilarVehicleItem {
  final String name;
  final String fare;
  final String rating;
  final IconData icon;
  final int id;
  final String? imagePath;
  final String? subtitle;
  final int tripsCompleted;
  final String? categoryKey;
  final String? categorySlug;

  SimilarVehicleItem({
    required this.name,
    required this.fare,
    required this.rating,
    required this.icon,
    required this.id,
    this.imagePath,
    this.subtitle,
    this.tripsCompleted = 0,
    this.categoryKey,
    this.categorySlug,
  });
}

class VehicleSimilarList extends StatelessWidget {
  final String titleKey;
  final IconData defaultIcon;
  final List<SimilarVehicleItem> vehicles;
  final Function(SimilarVehicleItem)? onItemTap;
  final bool showViewAll;

  const VehicleSimilarList({
    super.key,
    required this.titleKey,
    required this.defaultIcon,
    required this.vehicles,
    this.onItemTap,
    this.showViewAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final langController = Get.find<LanguageController>();

    // If no vehicles, don't show anything
    if (vehicles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Modern Header
        Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                          theme.colorScheme.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.recommend_rounded,
                      size: 20.sp,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Gap(12.w),
                  BText(
                    text: titleKey,
                    fontSize:
                        langController.currentLocale.value.languageCode == 'en'
                        ? 16.sp
                        : 12.sp,
                    fontWeight: FontWeight.w700,
                    isLocalized: true,
                  ),
                ],
              ),
              // ✅ FIX: Simplified view all - just shows a message or navigates to category
              if (showViewAll && vehicles.length > 2)
                GestureDetector(
                  onTap: () {
                    // ✅ Navigate to category page with the vehicle category
                    Get.toNamed(
                      Routes.similarVehicles,
                      arguments: {
                        'titleKey': titleKey,
                        'vehicles':
                            vehicles, // SimilarVehicleItem list pass பண்றோம்
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        BText(
                          text: 'view_all',
                          fontSize: 11.sp,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          isLocalized: true,
                        ),
                        Gap(4.w),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10.sp,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Gap(16.h),

        // Enhanced Horizontal List
        SizedBox(
          height: 200.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: vehicles.length,
            separatorBuilder: (_, __) => Gap(12.w),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];

              return InkWell(
                onTap: () {
                  if (onItemTap != null) {
                    onItemTap!(vehicle);
                  } else {
                    Get.toNamed(
                      Routes.unifiedVehicleDetail,
                      arguments: {'id': vehicle.id},
                      preventDuplicates: false,
                    );
                  }
                },
                child: Container(
                  width: 170.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE + OVERLAY
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22.r),
                              topRight: Radius.circular(22.r),
                            ),
                            child: SizedBox(
                              height: 110.h,
                              width: double.infinity,
                              child:
                                  vehicle.imagePath != null &&
                                      vehicle.imagePath!.isNotEmpty
                                  ? BCachedImage.document(
                                      imageUrl: vehicle.imagePath!,
                                      width: double.infinity,
                                      height: 110.h,
                                      borderRadius: 0,
                                    )
                                  : Container(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.08),
                                      child: Center(
                                        child: Icon(
                                          vehicle.icon,
                                          size: 32.sp,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                            ),
                          ),

                          /// GRADIENT OVERLAY
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(22.r),
                                  topRight: Radius.circular(22.r),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.25),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// RATING BADGE
                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 10.sp,
                                    color: Colors.amber,
                                  ),
                                  Gap(3.w),
                                  BText(
                                    text: vehicle.rating,
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    isLocalized: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// CONTENT
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// VEHICLE NAME
                            BText(
                              text: vehicle.name,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              isLocalized: false,
                            ),

                            if (vehicle.subtitle != null) ...[
                              Gap(3.h),
                              BText(
                                text: vehicle.subtitle!,
                                fontSize: 11.sp,
                                color: Colors.grey[600],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                isLocalized: false,
                              ),
                            ],

                            Gap(6.h),

                            /// TRIPS
                            if (vehicle.tripsCompleted > 0)
                              Row(
                                children: [
                                  Icon(
                                    Icons.route_rounded,
                                    size: 12.sp,
                                    color: Colors.grey[500],
                                  ),
                                  Gap(4.w),
                                  BText(
                                    text: '${vehicle.tripsCompleted} trips',
                                    fontSize: 11.sp,
                                    color: Colors.grey[600],
                                    isLocalized: false,
                                  ),
                                ],
                              ),

                            Gap(8.h),

                            /// PRICE
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BText(
                                  text: vehicle.fare,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.primary,
                                  isLocalized: false,
                                ),

                                /// small arrow CTA
                                Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14.sp,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}
