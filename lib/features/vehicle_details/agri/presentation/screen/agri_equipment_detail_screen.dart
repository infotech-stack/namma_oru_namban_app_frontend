// lib/features/vehicle_details/agri_equipment/screens/agri_equipment_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/agri/presentation/controller/agri_equipment_detail_controller.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_hero_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_stats_row.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_specs_container.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_reviews_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_similar_list.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_gradient_divider.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class AgriEquipmentDetailScreen extends GetView<AgriEquipmentDetailController> {
  AgriEquipmentDetailScreen({super.key});

  final _reviews = [
    ReviewData(
      name: 'Kumar',
      avatar: 'K',
      rating: 5,
      comment: 'Excellent harvester! Completed work quickly and efficiently.',
      date: '3 days ago',
    ),
    ReviewData(
      name: 'Ravi',
      avatar: 'R',
      rating: 4,
      comment: 'Good machine, well maintained. Operator was skilled.',
      date: '1 week ago',
    ),
    ReviewData(
      name: 'Selvam',
      avatar: 'S',
      rating: 5,
      comment: 'Best agricultural equipment service in our area!',
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
                    subtitle: controller.equipmentType.value,
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
                            labelKey: 'agri_capacity',
                            value: controller.capacity.value,
                            color: theme.colorScheme.primary,
                          ),
                          StatItem(
                            icon: Icons.local_gas_station_rounded,
                            labelKey: 'fuel_type',
                            value: controller.fuelType.value,
                            color: const Color(0xFF1E88E5),
                          ),
                          StatItem(
                            icon: Icons.build_rounded,
                            labelKey: 'condition',
                            value: controller.condition.value,
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
                        titleKey: 'agri_specifications',
                        headerIcon: Icons.tune_rounded,
                        specs: [
                          SpecItem(
                            labelKey: 'equipment_type',
                            value: controller.equipmentType.value,
                          ),
                          SpecItem(
                            labelKey: 'model_name',
                            value: controller.modelName.value,
                          ),
                          SpecItem(
                            labelKey: 'capacity',
                            value: controller.capacity.value,
                          ),
                          SpecItem(
                            labelKey: 'fuel_type',
                            value: controller.fuelType.value,
                          ),
                          SpecItem(
                            labelKey: 'condition',
                            value: controller.condition.value,
                          ),
                          SpecItem(
                            labelKey: 'base_price',
                            value: controller.basePrice.value,
                          ),
                          SpecItem(
                            labelKey: 'extra_hour',
                            value: controller.extraHourCharge.value,
                          ),
                          SpecItem(
                            labelKey: 'operator_bata',
                            value: controller.operatorBata.value,
                          ),
                          SpecItem(
                            labelKey: 'fuel_charge',
                            value: controller.fuelCharge.value,
                          ),
                        ],
                      ),
                    ),

                    Gap(24.h),

                    // Availability Section
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'agri_availability',
                        headerIcon: Icons.access_time_rounded,
                        specs: [], // Empty specs
                        customContent: Column(
                          children: [
                            _buildInfoRow(
                              theme,
                              'available_from',
                              controller.availableFrom.value,
                            ),
                            Gap(8.h),
                            _buildInfoRow(
                              theme,
                              'available_to',
                              controller.availableTo.value,
                            ),
                            Gap(8.h),
                            _buildInfoRow(
                              theme,
                              'min_booking',
                              controller.minBookingHours.value,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Gap(24.h),

                    // Suitable For Section
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'agri_suitable_for',
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
                      vehicleType: 'agri',
                    ),

                    Gap(24.h),

                    // Similar Equipment
                    VehicleSimilarList(
                      titleKey: 'similar_equipment',
                      defaultIcon: Icons.agriculture_rounded,
                      vehicles: [
                        SimilarVehicleItem(
                          name: 'Harvester',
                          fare: '₹1200/',
                          rating: '4.9',
                          icon: Icons.agriculture_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Rotavator',
                          fare: '₹500/',
                          rating: '4.7',
                          icon: Icons.agriculture_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Power Tiller',
                          fare: '₹600/',
                          rating: '4.8',
                          icon: Icons.agriculture_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'Sprayer',
                          fare: '₹300/',
                          rating: '4.6',
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

  Widget _buildInfoRow(ThemeData theme, String labelKey, String value) {
    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 14.sp,
          color: theme.colorScheme.primary,
        ),
        Gap(8.w),
        Expanded(
          child: BText(
            text: labelKey,
            fontSize: 12.sp,
            color: theme.dividerColor,
            isLocalized: true,
          ),
        ),
        BText(
          text: value,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
          isLocalized: false,
        ),
      ],
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
        onTap: Get.find<AgriEquipmentDetailController>().onBookNow,
        suffixIcon: Icon(
          Icons.arrow_circle_right_outlined,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
