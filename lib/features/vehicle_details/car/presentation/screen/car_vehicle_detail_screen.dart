// lib/features/vehicle_details/car/screens/car_vehicle_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';
import 'package:userapp/features/vehicle_details/car/presentation/controller/car_vehicle_detail_controller.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_gradient_divider.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_hero_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_reviews_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_similar_list.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_specs_container.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_stats_row.dart';

import 'package:userapp/utils/commons/button/b_button.dart';

class CarVehicleDetailScreen extends GetView<CarVehicleDetailController> {
  CarVehicleDetailScreen({super.key});

  final langController = Get.find<LanguageController>();

  final _reviews = [
    ReviewData(
      name: 'Arun Kumar',
      avatar: 'AK',
      rating: 5,
      comment:
          'Excellent service! Car was clean and driver was very professional.',
      date: '2 days ago',
    ),
    ReviewData(
      name: 'Priya S',
      avatar: 'PS',
      rating: 4,
      comment: 'Good experience overall. Arrived on time and safe delivery.',
      date: '1 week ago',
    ),
    ReviewData(
      name: 'Rajan M',
      avatar: 'RM',
      rating: 5,
      comment: 'Best car service in town! Will definitely book again.',
      date: '2 weeks ago',
    ),
    ReviewData(
      name: 'Divya K',
      avatar: 'DK',
      rating: 4,
      comment: 'Smooth experience. Driver was helpful and polite.',
      date: '3 weeks ago',
    ),
    ReviewData(
      name: 'Suresh P',
      avatar: 'SP',
      rating: 3,
      comment: 'Average service. Car was okay but slightly delayed.',
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
          bottomNavigationBar: _buildBookButton(theme),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Obx(
                  () => VehicleHeroSection(
                    vehicleName: controller.name.value,
                    rating: controller.rating.value,
                    fare: controller.fare.value,
                    fareUnit: '/km',
                    subtitle: 'ac_car'.tr,
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
                    // Stats Row - Using common widget
                    Obx(
                      () => VehicleStatsRow(
                        stats: [
                          StatItem(
                            icon: Icons.event_seat_rounded,
                            labelKey: 'seating',
                            value: controller.seatingCapacity.value,
                            color: theme.colorScheme.primary,
                          ),
                          StatItem(
                            icon: Icons.speed_rounded,
                            labelKey: 'transmission',
                            value: controller.transmission.value,
                            color: const Color(0xFF1E88E5),
                          ),
                          StatItem(
                            icon: Icons.local_gas_station_rounded,
                            labelKey: 'fuel_type',
                            value: controller.fuelType.value,
                            color: const Color(0xFFE53935),
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    // Gradient Divider - Using common widget
                    const VehicleGradientDivider(),

                    Gap(24.h),

                    // Specifications - Using common widget
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'car_specifications',
                        headerIcon: Icons.tune_rounded,
                        specs: [
                          SpecItem(
                            labelKey: 'manufacturer',
                            value: controller.manufacturer.value,
                          ),
                          SpecItem(
                            labelKey: 'model',
                            value: controller.model.value,
                          ),
                          SpecItem(
                            labelKey: 'seating',
                            value: controller.seatingCapacity.value,
                          ),
                          SpecItem(
                            labelKey: 'seat_type',
                            value: controller.seatType.value,
                          ),
                          SpecItem(
                            labelKey: 'fuel_type',
                            value: controller.fuelType.value,
                          ),
                          SpecItem(
                            labelKey: 'transmission',
                            value: controller.transmission.value,
                          ),
                          SpecItem(
                            labelKey: 'ac_available',
                            value: controller.acAvailable.value,
                          ),
                          SpecItem(
                            labelKey: 'music_system',
                            value: controller.musicSystem.value,
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    // Reviews Section - Using common widget
                    VehicleReviewsSection(
                      reviews: _reviews,
                      vehicleType: 'car',
                    ),

                    Gap(24.h),

                    // Similar Vehicles - Using common widget
                    VehicleSimilarList(
                      titleKey: 'similar_cars',
                      defaultIcon: Icons.directions_car_rounded,
                      vehicles: [
                        SimilarVehicleItem(
                          name: 'Toyota Innova',
                          fare: '₹40/',
                          rating: '4.8',
                          id: 0,
                          icon: Icons.directions_car_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Hyundai i20',
                          fare: '₹28/',
                          rating: '4.5',
                          id: 0,
                          icon: Icons.directions_car_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Maruti Swift',
                          id: 0,
                          fare: '₹25/',
                          rating: '4.3',
                          icon: Icons.directions_car_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Honda City',
                          id: 0,
                          fare: '₹35/',
                          rating: '4.6',
                          icon: Icons.directions_car_rounded,
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
