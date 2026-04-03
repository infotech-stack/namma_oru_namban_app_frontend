// lib/features/vehicle_details/tata_ace/screens/tata_ace_vehicle_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_gradient_divider.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_hero_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_reviews_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_similar_list.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_specs_container.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_stats_row.dart';
import 'package:userapp/features/vehicle_details/tata_ace/presentation/controller/tata_ace_vehicle_detail_controller.dart';
import 'package:userapp/utils/commons/button/b_button.dart';

class TataAceVehicleDetailScreen
    extends GetView<TataAceVehicleDetailController> {
  TataAceVehicleDetailScreen({super.key});

  final _reviews = [
    ReviewData(
      name: 'Senthil',
      avatar: 'S',
      rating: 5,
      comment: 'Perfect for small loads! Ace is reliable and driver was great.',
      date: '2 days ago',
    ),
    ReviewData(
      name: 'Mani',
      avatar: 'M',
      rating: 4,
      comment: 'Good service. Vehicle was clean and on time.',
      date: '1 week ago',
    ),
    ReviewData(
      name: 'Kannan',
      avatar: 'K',
      rating: 5,
      comment: 'Best mini truck for city deliveries. Highly recommended!',
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
                            labelKey: 'payload_capacity',
                            value: controller.payloadCapacity.value,
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
                        titleKey: 'tata_ace_specifications',
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
                            labelKey: 'payload_capacity',
                            value: controller.payloadCapacity.value,
                          ),
                          SpecItem(
                            labelKey: 'gross_weight',
                            value: controller.grossWeight.value,
                          ),
                          SpecItem(
                            labelKey: 'price_per_km',
                            value: controller.pricePerKm.value,
                          ),
                          SpecItem(
                            labelKey: 'price_per_trip',
                            value: controller.pricePerTrip.value,
                          ),
                          SpecItem(
                            labelKey: 'loading_base',
                            value: controller.loadingBase.value,
                          ),
                          SpecItem(
                            labelKey: 'driver_bata',
                            value: controller.driverBata.value,
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    // Usage Types Section
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'tata_ace_usage_types',
                        headerIcon: Icons.route_rounded,
                        specs: [], // Empty specs
                        customContent: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: controller.usageTypes.map((type) {
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
                                type.tr,
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
                      vehicleType: 'tata_ace',
                    ),

                    Gap(24.h),

                    // Similar Vehicles
                    VehicleSimilarList(
                      titleKey: 'similar_tata_ace',
                      defaultIcon: Icons.local_shipping_rounded,
                      vehicles: [
                        SimilarVehicleItem(
                          name: 'Tata Ace Gold',
                          fare: '₹18/', id: 0,
                          rating: '4.8',
                          icon: Icons.local_shipping_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Tata Ace Mega',
                          fare: '₹20/',
                          rating: '4.7',
                          icon: Icons.local_shipping_rounded, id: 0,
                        ),
                        SimilarVehicleItem(
                          name: 'Tata Ace Zip',
                          fare: '₹16/',
                          rating: '4.6',
                          icon: Icons.local_shipping_rounded, id: 0,
                        ),
                        SimilarVehicleItem(
                          name: 'Tata Ace EV',
                          fare: '₹15/',
                          rating: '4.9',
                          icon: Icons.local_shipping_rounded, id: 0,
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
        onTap: Get.find<TataAceVehicleDetailController>().onBookNow,
        suffixIcon: Icon(
          Icons.arrow_circle_right_outlined,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
