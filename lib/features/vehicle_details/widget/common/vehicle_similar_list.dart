// lib/features/vehicle_details/presentation/widgets/common/vehicle_similar_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class VehicleSimilarList extends StatelessWidget {
  final String titleKey;
  final List<SimilarVehicleItem> vehicles;
  final IconData? defaultIcon;
  final Function(String)? onItemTap;

  const VehicleSimilarList({
    super.key,
    required this.titleKey,
    required this.vehicles,
    this.defaultIcon = Icons.directions_car_rounded,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(7.r),
              decoration: BoxDecoration(
                color: p.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.grid_view_rounded, size: 16.sp, color: p),
            ),
            Gap(10.w),
            BText(
              text: titleKey,
              fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
              fontWeight: FontWeight.w700,
              isLocalized: true,
            ),
          ],
        ),
        Gap(14.h),
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: vehicles.length,
            separatorBuilder: (_, __) => Gap(10.w),
            itemBuilder: (_, i) {
              final v = vehicles[i];
              return GestureDetector(
                onTap: () => onItemTap?.call(v.name),
                child: Container(
                  width: 120.w,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        p.withValues(alpha: 0.10),
                        p.withValues(alpha: 0.04),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: p.withValues(alpha: 0.18)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: p.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(v.icon, size: 20.sp, color: p),
                      ),
                      Text(
                        v.name,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            v.fare,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: p,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 10.sp,
                                color: const Color(0xFFFFB300),
                              ),
                              Gap(2.w),
                              Text(
                                v.rating,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
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

class SimilarVehicleItem {
  final String name;
  final String fare;
  final String rating;
  final IconData icon;

  SimilarVehicleItem({
    required this.name,
    required this.fare,
    required this.rating,
    required this.icon,
  });
}
