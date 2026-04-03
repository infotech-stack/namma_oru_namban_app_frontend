import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/lorry/presentation/controller/lorry_vehicle_detail_controller.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_gradient_divider.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_hero_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_reviews_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_similar_list.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_specs_container.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_stats_row.dart';

import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class LorryVehicleDetailScreen extends GetView<LorryVehicleDetailController> {
  LorryVehicleDetailScreen({super.key});

  final _reviews = [
    ReviewData(
      name: 'Kumar',
      avatar: 'K',
      rating: 5,
      comment:
          'Excellent service! Lorry was clean and driver was professional.',
      date: '2 days ago',
    ),
    ReviewData(
      name: 'Rajan',
      avatar: 'R',
      rating: 4,
      comment: 'Good experience. On time delivery.',
      date: '1 week ago',
    ),
    ReviewData(
      name: 'Selvam',
      avatar: 'S',
      rating: 5,
      comment: 'Best lorry service in town!',
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
              // Hero Section - Using common widget
              SliverToBoxAdapter(
                child: Obx(
                  () => VehicleHeroSection(
                    vehicleName: controller.name.value,
                    rating: controller.rating.value,
                    fare: controller.fare.value,
                    fareUnit: controller.fareUnit.value,
                    subtitle: controller.vehicleType.value,
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
                            labelKey: 'load_capacity',
                            value: controller.loadCapacity.value,
                            color: theme.colorScheme.primary,
                          ),
                          StatItem(
                            icon: Icons.local_gas_station_rounded,
                            labelKey: 'fuel_type',
                            value: controller.fuelType.value,
                            color: const Color(0xFF1E88E5),
                          ),
                          StatItem(
                            icon: Icons.settings_rounded,
                            labelKey: 'body_type',
                            value: controller.bodyType.value,
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
                        titleKey: 'lorry_specifications',
                        headerIcon: Icons.tune_rounded,
                        specs: [
                          SpecItem(
                            labelKey: 'vehicle_model',
                            value: controller.vehicleModel.value,
                          ),
                          SpecItem(
                            labelKey: 'fuel_type',
                            value: controller.fuelType.value,
                          ),
                          SpecItem(
                            labelKey: 'body_type',
                            value: controller.bodyType.value,
                          ),
                          SpecItem(
                            labelKey: 'load_capacity',
                            value: controller.loadCapacity.value,
                          ),
                          SpecItem(
                            labelKey: 'loading_charge',
                            value: controller.loadingCharge.value,
                          ),
                          SpecItem(
                            labelKey: 'unloading_charge',
                            value: controller.unloadingCharge.value,
                          ),
                          SpecItem(
                            labelKey: 'driver_bata',
                            value: controller.driverBata.value,
                          ),
                          SpecItem(
                            labelKey: 'pricing_model',
                            value: controller.pricingModel.value,
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    // Load Types Section - Using custom content
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'suitable_load_types',
                        headerIcon: Icons.inventory_2_rounded,
                        specs: [], // Empty specs
                        customContent: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: controller.loadTypes.map((type) {
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
                              child: BText(
                                text: type,
                                fontSize: 11.sp,
                                color: theme.colorScheme.primary,
                                isLocalized: true,
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
                      vehicleType: 'lorry',
                    ),

                    Gap(24.h),

                    // Similar Vehicles
                    VehicleSimilarList(
                      titleKey: 'similar_lorries',
                      defaultIcon: Icons.local_shipping_rounded,
                      vehicles: [
                        SimilarVehicleItem(
                          name: 'Tata 407',
                          fare: '₹35/',
                          id: 0,
                          rating: '4.8',
                          icon: Icons.local_shipping_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Ashok Leyland',
                          id: 0,
                          fare: '₹40/',
                          rating: '4.5',
                          icon: Icons.local_shipping_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Eicher Pro',
                          fare: '₹38/',
                          id: 0,
                          rating: '4.3',
                          icon: Icons.local_shipping_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'BharatBenz',
                          id: 0,
                          fare: '₹42/',
                          rating: '4.6',
                          icon: Icons.local_shipping_rounded,
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
        onTap: controller.onBookNow,
        suffixIcon: Icon(
          Icons.arrow_circle_right_outlined,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
