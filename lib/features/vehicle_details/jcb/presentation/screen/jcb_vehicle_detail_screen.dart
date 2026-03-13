// lib/features/vehicle_details/jcb/screens/jcb_vehicle_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/jcb/presentation/controller/jcb_vehicle_detail_controller.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_gradient_divider.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_hero_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_reviews_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_similar_list.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_specs_container.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_stats_row.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class JcbVehicleDetailScreen extends GetView<JcbVehicleDetailController> {
  JcbVehicleDetailScreen({super.key});

  final _reviews = [
    ReviewData(
      name: 'Muthu',
      avatar: 'M',
      rating: 5,
      comment: 'Excellent JCB service! Finished excavation work quickly.',
      date: '3 days ago',
    ),
    ReviewData(
      name: 'Karthik',
      avatar: 'K',
      rating: 4,
      comment: 'Good machine, skilled operator. Worked well in tight space.',
      date: '1 week ago',
    ),
    ReviewData(
      name: 'Sundar',
      avatar: 'S',
      rating: 5,
      comment: 'Best JCB for construction work. Highly recommend!',
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
                    subtitle: controller.machineType.value,
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
                            icon: Icons.hardware_rounded,
                            labelKey: 'bucket_type',
                            value: controller.bucketType.value,
                            color: theme.colorScheme.primary,
                          ),
                          StatItem(
                            icon: Icons.local_gas_station_rounded,
                            labelKey: 'fuel_type',
                            value: controller.fuelType.value,
                            color: const Color(0xFF1E88E5),
                          ),
                          StatItem(
                            icon: Icons.speed_rounded,
                            labelKey: 'machine_age',
                            value: controller.machineAge.value,
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
                        titleKey: 'jcb_specifications',
                        headerIcon: Icons.tune_rounded,
                        specs: [
                          SpecItem(
                            labelKey: 'jcb_model',
                            value: controller.jcbModel.value,
                          ),
                          SpecItem(
                            labelKey: 'bucket_type',
                            value: controller.bucketType.value,
                          ),
                          SpecItem(
                            labelKey: 'fuel_type',
                            value: controller.fuelType.value,
                          ),
                          SpecItem(
                            labelKey: 'machine_age',
                            value: controller.machineAge.value,
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

                    // Working Areas Section
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'jcb_working_areas',
                        headerIcon: Icons.location_on_rounded,
                        specs: [], // Empty specs
                        customContent: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: controller.workingAreas.map((area) {
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    size: 12.sp,
                                    color: theme.colorScheme.primary,
                                  ),
                                  Gap(4.w),
                                  Text(
                                    area,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    Gap(24.h),

                    // Charging Options
                    Obx(
                      () => VehicleSpecsContainer(
                        titleKey: 'jcb_charging_options',
                        headerIcon: Icons.receipt_long_rounded,
                        specs: [], // Empty specs
                        customContent: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            if (controller.chargePerHour.value)
                              _buildChargingChip(theme, 'jcb_charge_per_hour'),
                            if (controller.chargePerLoad.value)
                              _buildChargingChip(theme, 'jcb_charge_per_load'),
                          ],
                        ),
                      ),
                    ),

                    Gap(24.h),

                    // Reviews Section
                    VehicleReviewsSection(
                      reviews: _reviews,
                      vehicleType: 'jcb',
                    ),

                    Gap(24.h),

                    // Similar JCBs
                    VehicleSimilarList(
                      titleKey: 'similar_jcbs',
                      defaultIcon: Icons.construction_rounded,
                      vehicles: [
                        SimilarVehicleItem(
                          name: 'JCB 3DX',
                          fare: '₹800/',
                          rating: '4.8',
                          icon: Icons.construction_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'JCB 3DX Super',
                          fare: '₹900/',
                          rating: '4.7',
                          icon: Icons.construction_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'JCB JS81',
                          fare: '₹1100/',
                          rating: '4.9',
                          icon: Icons.construction_rounded,
                        ),
                        SimilarVehicleItem(
                          name: 'KOMATSU',
                          fare: '₹1500/',
                          rating: '4.8',
                          icon: Icons.construction_rounded,
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

  Widget _buildChargingChip(ThemeData theme, String labelKey) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.30),
        ),
      ),
      child: BText(
        text: labelKey,
        fontSize: 12.sp,
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
        isLocalized: true,
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
        onTap: Get.find<JcbVehicleDetailController>().onBookNow,
        suffixIcon: Icon(
          Icons.arrow_circle_right_outlined,
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
