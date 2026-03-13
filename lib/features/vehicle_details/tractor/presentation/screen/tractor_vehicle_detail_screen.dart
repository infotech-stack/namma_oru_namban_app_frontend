// lib/features/vehicle_details/tractor/screens/tractor_vehicle_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/tractor/presentation/controller/tractor_vehicle_detail_controller.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_hero_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_stats_row.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_specs_container.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_reviews_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_similar_list.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_gradient_divider.dart';
import 'package:userapp/utils/commons/button/b_button.dart';

class TractorVehicleDetailScreen
    extends GetView<TractorVehicleDetailController> {
  TractorVehicleDetailScreen({super.key});

  final _reviews = [
    ReviewData(
      name: 'Velmurugan',
      avatar: 'V',
      rating: 5,
      comment:
          'Excellent tractor! Powerful and fuel efficient. Operator was skilled.',
      date: '2 days ago',
    ),
    ReviewData(
      name: 'Selvam',
      avatar: 'S',
      rating: 4,
      comment: 'Good for ploughing. Completed work on time.',
      date: '1 week ago',
    ),
    ReviewData(
      name: 'Muthu',
      avatar: 'M',
      rating: 5,
      comment: 'Best tractor service in our area. Highly recommended!',
      date: '2 weeks ago',
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
          bottomNavigationBar: _buildBookButton(theme),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Section
              SliverToBoxAdapter(
                child: Obx(
                  () => VehicleHeroSection(
                    vehicleName: controller.name.value,
                    rating: controller.rating.value,
                    fare: controller.fare.value,
                    fareUnit: controller.fareUnit.value,
                    subtitle: controller.tractorCategory.value,
                    tripsCompleted: controller.tripsCompleted.value,
                    vehicleImages: controller.vehicleImages,
                    onBack: () => Get.back(),
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Stats Row
                    Obx(
                      () => VehicleStatsRow(
                        stats: [
                          StatItem(
                            icon: Icons.speed_rounded,
                            labelKey: 'tractor_hp',
                            value: controller.horsePower.value,
                            color: theme.colorScheme.primary,
                          ),
                          StatItem(
                            icon: Icons.power_rounded,
                            labelKey: 'tractor_category',
                            value: controller.tractorCategory.value,
                            color: const Color(0xFF1E88E5),
                          ),
                          StatItem(
                            icon: Icons.build_rounded,
                            labelKey: 'tractor_attachment',
                            value: controller.attachment.value,
                            color: const Color(0xFFE53935),
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),
                    const VehicleGradientDivider(),
                    Gap(24.h),

                    // Specifications
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'tractor_specifications',
                        headerIcon: Icons.tune_rounded,
                        specs: [
                          SpecItem(
                            labelKey: 'tractor_category',
                            value: controller.tractorCategory.value,
                          ),
                          SpecItem(
                            labelKey: 'tractor_brand',
                            value: controller.brand.value,
                          ),
                          SpecItem(
                            labelKey: 'tractor_hp',
                            value: controller.horsePower.value,
                          ),
                          SpecItem(
                            labelKey: 'tractor_attachment',
                            value: controller.attachment.value,
                          ),
                          SpecItem(
                            labelKey: 'base_price',
                            value: controller.basePrice.value,
                          ),
                          SpecItem(
                            labelKey: 'available_hours',
                            value: controller.availableHours.value,
                          ),
                          SpecItem(
                            labelKey: 'min_hours',
                            value: controller.minHours.value,
                          ),
                          SpecItem(
                            labelKey: 'operator_charge',
                            value: controller.operatorCharge.value,
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    // Suitable For Section
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'tractor_suitable_for',
                        headerIcon: Icons.check_circle_rounded,
                        specs: [], // Empty specs
                        customContent: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: controller.suitableFor.map((item) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.30,
                                  ),
                                ),
                              ),
                              child: Text(
                                item.tr,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    Gap(24.h),

                    // Reviews Section
                    VehicleReviewsSection(
                      reviews: _reviews,
                      vehicleType: 'tractor',
                    ),

                    Gap(24.h),

                    // Similar Tractors
                    VehicleSimilarList(
                      titleKey: 'similar_tractors',
                      defaultIcon: Icons.agriculture_rounded,
                      vehicles: [
                        SimilarVehicleItem(
                          name: 'Mahindra 475',
                          fare: '₹700/',
                          rating: '4.8',
                          icon: Icons.agriculture_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'John Deere 5050',
                          fare: '₹850/',
                          rating: '4.9',
                          icon: Icons.agriculture_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Sonalika 750',
                          fare: '₹750/',
                          rating: '4.7',
                          icon: Icons.agriculture_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'TAFE 744',
                          fare: '₹800/',
                          rating: '4.8',
                          icon: Icons.agriculture_rounded,
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookButton(ThemeData theme) {
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
        text: 'book_now',
        onTap: Get.find<TractorVehicleDetailController>().onBookNow,
        suffixIcon: Icon(
          Icons.arrow_circle_right_outlined,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
