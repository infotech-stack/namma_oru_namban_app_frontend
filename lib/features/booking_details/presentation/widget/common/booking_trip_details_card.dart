// lib/features/booking/presentation/widgets/common/booking_trip_details_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_info_box.dart';
import 'package:userapp/utils/commons/textfield/b_textfiled.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';


class BookingTripDetailsCard extends StatelessWidget {
  final TextEditingController pickupController;
  final TextEditingController dropController;
  final String distance;
  final String time;
  final VoidCallback? onPickupChanged;
  final VoidCallback? onDropChanged;

  const BookingTripDetailsCard({
    super.key,
    required this.pickupController,
    required this.dropController,
    required this.distance,
    required this.time,
    this.onPickupChanged,
    this.onDropChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BookingCardDecoration(theme: theme),
      child: Column(
        children: [
          BTextField(
            controller: pickupController,
            labelText: 'pickup_address',
            hintText: 'hint_pickup',
            isLocalized: true,
            prefixIcon: Icon(
              Icons.location_on_rounded,
              color: AppTheme.red,
              size: 18.sp,
            ),
          ),
          Gap(12.h),
          BTextField(
            controller: dropController,
            labelText: 'drop_address',
            hintText: 'hint_drop',
            isLocalized: true,
            prefixIcon: Icon(
              Icons.location_on_rounded,
              color: theme.dividerColor,
              size: 18.sp,
            ),
          ),
          Gap(14.h),
          Row(
            children: [
              Expanded(
                child: BookingInfoBox(
                  label: 'distance',
                  value: distance,
                  valueColor: theme.colorScheme.primary,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: BookingInfoBox(
                  label: 'time',
                  value: time,
                  valueColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
