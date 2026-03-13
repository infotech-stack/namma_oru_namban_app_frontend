// lib/features/vehicle_details/presentation/widgets/common/vehicle_hero_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/features/vehicle_details/presentation/widget/vehicle_carousal_image_widget.dart';

class VehicleHeroSection extends StatelessWidget {
  final String vehicleName;
  final String rating;
  final String fare;
  final String fareUnit;
  final String subtitle;
  final String tripsCompleted;
  final List<String?> vehicleImages;
  final VoidCallback onBack;

  const VehicleHeroSection({
    super.key,
    required this.vehicleName,
    required this.rating,
    required this.fare,
    required this.fareUnit,
    required this.subtitle,
    required this.tripsCompleted,
    required this.vehicleImages,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final langController = Get.find<LanguageController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar with back, language and fare
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                GestureDetector(
                  onTap: onBack,
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

                // Language toggle and fare
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
                            fare,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            fareUnit,
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

        // Vehicle Name and Rating
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  vehicleName,
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
                      rating,
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

        // Subtitle with verified badge
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
                  '$subtitle • ${'available_247'.tr} • $tripsCompleted ${'trips_completed'.tr}',
                  style: TextStyle(fontSize: 11.sp, color: theme.dividerColor),
                ),
              ),
            ],
          ),
        ),
        Gap(16.h),

        // Image Carousel
        VehicleImageCarousel(
          images: vehicleImages,
          height: 220,
          autoScrollDuration: const Duration(seconds: 3),
          animationDuration: const Duration(milliseconds: 500),
        ),

        Gap(8.h),
      ],
    );
  }
}
