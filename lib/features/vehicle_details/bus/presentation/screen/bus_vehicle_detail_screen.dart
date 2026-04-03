// lib/features/vehicle_details/bus/screens/bus_vehicle_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/bus/presentation/controller/bus_vehicle_detail_controller.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_gradient_divider.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_hero_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_reviews_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_similar_list.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_specs_container.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_stats_row.dart';

import 'package:userapp/utils/commons/button/b_button.dart';

class BusVehicleDetailScreen extends GetView<BusVehicleDetailController> {
  BusVehicleDetailScreen({super.key});

  final _reviews = [
    ReviewData(
      name: 'Rajesh Kumar',
      avatar: 'RK',
      rating: 5,
      comment:
          'Very comfortable bus! On time and clean. Driver was professional.',
      date: '3 days ago',
    ),
    ReviewData(
      name: 'Priya R',
      avatar: 'PR',
      rating: 4,
      comment: 'Good experience. AC was perfect and seats comfortable.',
      date: '1 week ago',
    ),
    ReviewData(
      name: 'Suresh M',
      avatar: 'SM',
      rating: 5,
      comment: 'Best bus service for tours. Highly recommended!',
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
                    subtitle: controller.busType.value,
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
                            icon: Icons.event_seat_rounded,
                            labelKey: 'seating_capacity',
                            value: controller.seatingCapacity.value,
                            color: theme.colorScheme.primary,
                          ),
                          StatItem(
                            icon: Icons.ac_unit_rounded,
                            labelKey: 'ac_available',
                            value: controller.acAvailable.value,
                            color: const Color(0xFF1E88E5),
                          ),
                          StatItem(
                            icon: Icons.speed_rounded,
                            labelKey: 'bus_type',
                            value: controller.busCategory.value,
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
                        titleKey: 'bus_specifications',
                        headerIcon: Icons.tune_rounded,
                        specs: [
                          SpecItem(
                            labelKey: 'bus_category',
                            value: controller.busCategory.value,
                          ),
                          SpecItem(
                            labelKey: 'manufacturer',
                            value: controller.manufacturer.value,
                          ),
                          SpecItem(
                            labelKey: 'seating_capacity',
                            value: controller.seatingCapacity.value,
                          ),
                          SpecItem(
                            labelKey: 'seat_type',
                            value: controller.seatType.value,
                          ),
                          SpecItem(
                            labelKey: 'ac_available',
                            value: controller.acAvailable.value,
                          ),
                          SpecItem(
                            labelKey: 'charging_points',
                            value: controller.chargingPoints.value,
                          ),
                          SpecItem(
                            labelKey: 'entertainment',
                            value: controller.entertainment.value,
                          ),
                          SpecItem(
                            labelKey: 'toilet',
                            value: controller.toilet.value,
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    // Amenities Section
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'bus_amenities',
                        headerIcon: Icons.star_rounded,
                        specs: [], // Empty specs
                        customContent: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: controller.amenities.map((amenity) {
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
                                amenity.tr,
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
                      vehicleType: 'bus',
                    ),

                    Gap(24.h),

                    // Similar Buses
                    VehicleSimilarList(
                      titleKey: 'similar_buses',
                      defaultIcon: Icons.directions_bus_rounded,
                      vehicles: [
                        SimilarVehicleItem(
                          name: 'Semi Sleeper Bus',
                          fare: '₹45/',
                          rating: '4.8',
                          icon: Icons.directions_bus_rounded,
                          id: 0,
                        ),
                        SimilarVehicleItem(
                          name: 'Luxury Seater',
                          fare: '₹55/',
                          rating: '4.7',
                          icon: Icons.directions_bus_rounded,
                          id: 0,
                        ),
                        SimilarVehicleItem(
                          name: 'Town Bus',
                          fare: '₹35/',
                          id: 0,
                          rating: '4.5',
                          icon: Icons.directions_bus_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Sleeper Bus',
                          fare: '₹60/',
                          id: 0,
                          rating: '4.9',
                          icon: Icons.directions_bus_rounded,
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
        onTap: Get.find<BusVehicleDetailController>().onBookNow,
        suffixIcon: Icon(
          Icons.arrow_circle_right_outlined,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
