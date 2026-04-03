// lib/features/vehicle_details/widget/common/similar_vehicles_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/vehicle_details/presentation/controller/unified_vehicle_detail_controller.dart';
import 'package:userapp/utils/commons/app_bar/b_app_bar.dart';
import 'package:userapp/utils/commons/catch_image/app_catch_image.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class SimilarVehiclesScreen extends GetView<UnifiedVehicleDetailController> {
  const SimilarVehiclesScreen({super.key});
  void _onVehicleTap(dynamic vehicle) {
    Get.delete<UnifiedVehicleDetailController>(force: true);
    Get.toNamed(
      Routes.unifiedVehicleDetail,
      arguments: {'id': vehicle.id},
      preventDuplicates: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = Get.arguments as Map<String, dynamic>;
    final String titleKey = args['titleKey'] ?? 'similar_vehicles';
    final List vehicles = args['vehicles'] ?? [];

    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      appBar: BAppBar(title: titleKey, showBackButton: true),

      body: vehicles.isEmpty
          ? Center(
              child: BText(
                text: 'no_vehicles_found',
                fontSize: 14.sp,
                color: Colors.grey,
                isLocalized: true,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.78,
                ),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return _SimilarVehicleCard(
                    vehicle: vehicle,
                    theme: theme,
                    onTap: () => _onVehicleTap(vehicle),
                  );
                },
              ),
            ),
    );
  }
}

class _SimilarVehicleCard extends StatelessWidget {
  final dynamic vehicle;
  final ThemeData theme;
  final VoidCallback onTap;

  const _SimilarVehicleCard({
    required this.vehicle,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  child: SizedBox(
                    height: 120.h,
                    width: double.infinity,
                    child:
                        vehicle.imagePath != null &&
                            vehicle.imagePath!.isNotEmpty
                        ? BCachedImage.document(
                            imageUrl: vehicle.imagePath!,
                            width: double.infinity,
                            height: 120.h,
                            borderRadius: 0,
                          )
                        : Container(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.08,
                            ),
                            child: Center(
                              child: Icon(
                                vehicle.icon,
                                size: 36.sp,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                  ),
                ),
                // RATING BADGE
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 10.sp, color: Colors.amber),
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

            // CONTENT
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BText(
                    text: vehicle.name,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    isLocalized: false,
                  ),
                  Gap(4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BText(
                          text: vehicle.fare,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                          isLocalized: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 12.sp,
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
  }
}
