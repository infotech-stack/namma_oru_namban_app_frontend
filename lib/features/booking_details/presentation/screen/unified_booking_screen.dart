// lib/features/booking/unified/screens/unified_booking_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/booking_details/presentation/controller/unified_booking_controller.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_confirm_button.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_driver_card.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_fare_card.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_instructions_card.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_payment_card.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_promo_card.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_rate_type_toggle.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_safety_card.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_schedule_card.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_section_title.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_service_row.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_trip_details_card.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_vehicle_card.dart';
import 'package:userapp/utils/commons/app_bar/b_app_bar.dart';

class UnifiedBookingScreen extends GetView<UnifiedBookingController> {
  const UnifiedBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: BAppBar(
          title: _getTitleKey(),
          showLanguageToggle: true,
          showBackButton: true,
        ),
        body: Obx(() {
          final b = controller.booking.value;
          if (b == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehicle Card
                      BookingVehicleCard(
                        vehicleName: b.vehicleName,
                        vehicleImagePath: b.vehicleImagePath,
                        pricePerKm: _getPriceDisplay(),
                        eta: _getEtaDisplay(),
                        capacity1: _getCapacity1(),
                        capacity2: _getCapacity2(),
                        driverName: b.driverName,
                        driverRating: b.driverRating,
                        vehicleIcon: controller.getVehicleIcon(),
                      ),
                      Gap(16.h),

                      // Trip Details
                      const BookingSectionTitle(titleKey: 'trip_details'),
                      Gap(10.h),
                      BookingTripDetailsCard(
                        pickupController: controller.pickupController,
                        dropController: controller.dropController,
                        distance:
                            '${b.estimatedDistanceKm.toStringAsFixed(1)} km',
                        time: _getEstimatedTime(),
                      ),
                      Gap(16.h),

                      // Schedule Booking
                      const BookingSectionTitle(titleKey: 'schedule_booking'),
                      Gap(10.h),
                      BookingScheduleCard(
                        isBookNow: b.isBookNow,

                        scheduleDate: DateFormat(
                          'dd-MM-yyyy',
                        ).format(b.scheduledAt ?? DateTime.now()),

                        scheduleTime: DateFormat(
                          'hh:mm a',
                        ).format(b.scheduledAt ?? DateTime.now()),

                        onToggleBookNow: controller.toggleBookNow,
                        onDateSelected: controller.onDateSelected,
                        onTimeSelected: controller.onTimeSelected,
                      ),
                      Gap(16.h),

                      /*  // Driver/Operator Details
                      BookingSectionTitle(titleKey: _getDriverTitleKey()),
                      Gap(10.h),
                      BookingDriverCard(
                        driverName: b.driverName,
                        driverRating: b.driverRating,
                        vehicleNumber: b.vehicleNumber,
                        experience: _getExperience(),
                        onCallDriver: controller.onCallDriver,
                      ),
                      Gap(16.h),

                      // Rate Type Toggle
                      BookingRateTypeToggle(
                        options: controller.rateTypeOptions,
                        selectedType: b.selectedRateType,
                        onTypeSelected: controller.selectRateType,
                        crossAxisCount: controller.rateTypeOptions.length > 2
                            ? 3
                            : 2,
                      ),
                      Gap(16.h),*/

                      // Additional Services
                      if (controller.serviceOptions.isNotEmpty) ...[
                        const BookingSectionTitle(
                          titleKey: 'additional_services',
                        ),
                        Gap(10.h),
                        Container(
                          decoration: BookingCardDecoration(theme: theme),
                          child: Column(
                            children: [
                              for (
                                int i = 0;
                                i < controller.serviceOptions.length;
                                i++
                              )
                                _buildServiceRow(
                                  theme,
                                  controller.serviceOptions[i],
                                  isFirst: i == 0,
                                  isLast:
                                      i == controller.serviceOptions.length - 1,
                                ),
                            ],
                          ),
                        ),
                        Gap(16.h),
                      ],

                      // Special Instructions
                      const BookingSectionTitle(
                        titleKey: 'special_instructions',
                      ),
                      Gap(10.h),
                      BookingInstructionsCard(
                        controller: controller.instructionsController,
                        hintTextKey: _getInstructionsHintKey(),
                        exampleTextKey: _getInstructionsExampleKey(),
                      ),
                      Gap(16.h),

                      // Estimated Fare
                      const BookingSectionTitle(titleKey: 'estimated_fare'),
                      Gap(10.h),
                      BookingFareCard(
                        fareRows: _getFareRows(b),
                        totalEstimate: '₹${b.totalEstimate.toStringAsFixed(0)}',
                      ),
                      Gap(16.h),

                      // Promo Code
                      const BookingSectionTitle(titleKey: 'apply_promo_code'),
                      Gap(10.h),
                      BookingPromoCard(
                        controller: controller.promoTextController,
                        promoApplied: b.promoApplied,
                        promoMessage: b.promoMessage,
                        onApply: controller.applyPromoCode,
                      ),
                      Gap(16.h),

                      // Payment Method
                      const BookingSectionTitle(titleKey: 'payment_method'),
                      Gap(10.h),
                      BookingPaymentCard(
                        options: controller.paymentOptions
                            .map(
                              (option) => PaymentOption(
                                type: option,
                                label: option,
                                icon:
                                    controller.paymentIcons[option] ??
                                    Icons.payment_rounded,
                              ),
                            )
                            .toList(),
                        selectedPayment: b.paymentMethod,
                        onPaymentSelected: controller.selectPayment,
                      ),
                      Gap(16.h),

                      // Safety Assurance
                      const BookingSectionTitle(titleKey: 'safety_assurance'),
                      Gap(10.h),
                      BookingSafetyCard(
                        items: [
                          SafetyItem(
                            icon: Icons.verified_rounded,
                            iconColor: AppTheme.green,
                            bgColor: AppTheme.green.withValues(alpha: 0.12),
                            labelKey: _getSafetyLabelKey(),
                          ),
                          SafetyItem(
                            icon: Icons.headset_mic_rounded,
                            iconColor: theme.colorScheme.primary,
                            bgColor: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            labelKey: 'support_24_7',
                          ),
                        ],
                      ),
                      Gap(24.h),
                    ],
                  ),
                ),
              ),
              BookingConfirmButton(
                onConfirm: controller.onConfirmBooking,
                // isLoading: controller.isBooking.value,
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildServiceRow(
    ThemeData theme,
    ServiceOption service, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        if (!isFirst) BookingServiceDivider(theme: theme),
        BookingServiceRow(
          labelKey: service.labelKey,
          price: service.isPercentage
              ? '50% off'
              : '+₹${service.price.toStringAsFixed(0)}',
          value: controller.getServiceValue(service.labelKey),
          onChanged: (val) => controller.toggleService(service.labelKey, val),
          isFirst: isFirst,
          isLast: isLast,
          isPriceColored: service.isPercentage,
          priceColor: service.isPercentage ? theme.colorScheme.primary : null,
        ),
      ],
    );
  }

  List<FareRowItem> _getFareRows(UnifiedBookingModel b) {
    final rows = <FareRowItem>[
      FareRowItem(
        label: 'base_fare',
        value: '₹${b.baseFare.toStringAsFixed(0)}',
      ),
    ];

    if (b.distanceFare > 0) {
      rows.add(
        FareRowItem(
          label: b.selectedRateType == 'km' ? 'distance_fare' : 'duration_fare',
          value: '₹${b.distanceFare.toStringAsFixed(0)}',
          isLocalized: false,
        ),
      );
    }

    // Add operator/driver charge
    final operatorLabel =
        b.vehicleType == VehicleType.car ||
            b.vehicleType == VehicleType.bus ||
            b.vehicleType == VehicleType.miniBus ||
            b.vehicleType == VehicleType.heavyLorry ||
            b.vehicleType == VehicleType.tataAce
        ? 'driver_bata'
        : 'operator_bata';

    final operatorCharge =
        b.vehicleType == VehicleType.car ||
            b.vehicleType == VehicleType.bus ||
            b.vehicleType == VehicleType.miniBus ||
            b.vehicleType == VehicleType.heavyLorry ||
            b.vehicleType == VehicleType.tataAce
        ? b.driverBata
        : b.operatorBata;

    if (operatorCharge > 0) {
      rows.add(
        FareRowItem(
          label: operatorLabel,
          value: '₹${operatorCharge.toStringAsFixed(0)}',
        ),
      );
    }

    // Add additional charges
    if (b.additionalCharges > 0) {
      rows.add(
        FareRowItem(
          label: 'additional_services',
          value: '₹${b.additionalCharges.toStringAsFixed(0)}',
        ),
      );
    }

    rows.add(
      FareRowItem(
        label: 'platform_fee',
        value: '₹${b.platformFee.toStringAsFixed(0)}',
      ),
    );
    rows.add(
      FareRowItem(label: 'gst', value: '₹${b.gstAmount.toStringAsFixed(0)}'),
    );

    if (b.discountAmount > 0) {
      rows.add(
        FareRowItem(
          label: 'discount',
          value: '-₹${b.discountAmount.toStringAsFixed(0)}',
        ),
      );
    }

    return rows;
  }

  String _getTitleKey() {
    final type = controller.booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
        return 'car_booking_title';
      case VehicleType.bus:
      case VehicleType.miniBus:
        return 'bus_booking_title';
      case VehicleType.jcb:
        return 'jcb_booking_title';
      case VehicleType.heavyLorry:
        return 'lorry_booking_title';
      case VehicleType.tataAce:
        return 'tata_ace_booking_title';
      case VehicleType.tractor:
        return 'tractor_booking_title';
      case VehicleType.agriEquipment:
        return 'agri_booking_title';
    }
  }

  String _getDriverTitleKey() {
    final type = controller.booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
      case VehicleType.bus:
      case VehicleType.miniBus:
      case VehicleType.heavyLorry:
      case VehicleType.tataAce:
        return 'driver_details';
      case VehicleType.jcb:
      case VehicleType.tractor:
      case VehicleType.agriEquipment:
        return 'operator_details';
    }
  }

  String _getSafetyLabelKey() {
    final type = controller.booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
      case VehicleType.bus:
      case VehicleType.miniBus:
      case VehicleType.heavyLorry:
      case VehicleType.tataAce:
        return 'verified_driver';
      case VehicleType.jcb:
      case VehicleType.tractor:
      case VehicleType.agriEquipment:
        return 'verified_operator';
    }
  }

  String _getPriceDisplay() {
    final b = controller.booking.value;
    if (b == null) return '';

    if (b.selectedRateType == 'km') {
      return '₹${b.farePerKm.toStringAsFixed(0)}/km';
    } else if (b.selectedRateType == 'hour') {
      return '₹${b.extraHourCharge.toStringAsFixed(0)}/hr';
    } else {
      return '₹${b.basePrice.toStringAsFixed(0)}/${b.selectedRateType}';
    }
  }

  String _getEtaDisplay() {
    final b = controller.booking.value;
    if (b == null) return '';

    final type = b.vehicleType;
    switch (type) {
      case VehicleType.car:
        return 'ETA: 15 mins';
      case VehicleType.bus:
      case VehicleType.miniBus:
        return 'ETA: 45 mins';
      case VehicleType.jcb:
        return 'ETA: 60 mins';
      case VehicleType.heavyLorry:
      case VehicleType.tataAce:
        return 'ETA: 45 mins';
      case VehicleType.tractor:
        return 'ETA: 60 mins';
      case VehicleType.agriEquipment:
        return 'ETA: 90 mins';
    }
  }

  String _getEstimatedTime() {
    final b = controller.booking.value;
    if (b == null) return '';

    if (b.selectedRateType == 'hour') {
      return '${b.estimatedDurationHr.toStringAsFixed(0)} hrs';
    }
    return '${(b.estimatedDistanceKm / 40 * 60).toStringAsFixed(0)} mins';
  }

  String _getCapacity1() {
    final b = controller.booking.value;
    if (b == null) return '';

    final type = b.vehicleType;
    switch (type) {
      case VehicleType.car:
        return b.seatingCapacity ?? '5 Seats';
      case VehicleType.bus:
      case VehicleType.miniBus:
        return b.seatingCapacity ?? '40 Seats';
      case VehicleType.jcb:
        return b.bucketType ?? 'Big Bucket';
      case VehicleType.heavyLorry:
      case VehicleType.tataAce:
        return b.loadCapacity ?? '5 Ton';
      case VehicleType.tractor:
        return b.horsePower ?? '45 HP';
      case VehicleType.agriEquipment:
        return b.capacity ?? '5 acres/hr';
    }
  }

  String _getCapacity2() {
    final b = controller.booking.value;
    if (b == null) return '';

    final type = b.vehicleType;
    switch (type) {
      case VehicleType.car:
        return 'AC Car';
      case VehicleType.bus:
      case VehicleType.miniBus:
        return b.busCategory ?? 'Luxury Bus';
      case VehicleType.jcb:
        return b.fuelType ?? 'Diesel';
      case VehicleType.heavyLorry:
      case VehicleType.tataAce:
        return b.bodyType ?? 'Open Body';
      case VehicleType.tractor:
        return b.attachment ?? 'Rotavator';
      case VehicleType.agriEquipment:
        return b.equipmentType ?? 'Harvester';
    }
  }

  String _getExperience() {
    final type = controller.booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
        return '5 ${'years_experience'.tr}';
      case VehicleType.bus:
      case VehicleType.miniBus:
        return '7 ${'years_experience'.tr}';
      case VehicleType.jcb:
        return '6 ${'years_experience'.tr}';
      case VehicleType.heavyLorry:
        return '8 ${'years_experience'.tr}';
      case VehicleType.tataAce:
        return '5 ${'years_experience'.tr}';
      case VehicleType.tractor:
        return '7 ${'years_experience'.tr}';
      case VehicleType.agriEquipment:
        return '8 ${'years_experience'.tr}';
    }
  }

  String _getInstructionsHintKey() {
    final type = controller.booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
        return 'car_instructions_hint';
      case VehicleType.bus:
      case VehicleType.miniBus:
        return 'bus_instructions_hint';
      case VehicleType.jcb:
        return 'jcb_instructions_hint';
      case VehicleType.heavyLorry:
        return 'lorry_instructions_hint';
      case VehicleType.tataAce:
        return 'tata_ace_instructions_hint';
      case VehicleType.tractor:
        return 'tractor_instructions_hint';
      case VehicleType.agriEquipment:
        return 'agri_instructions_hint';
    }
  }

  String _getInstructionsExampleKey() {
    final type = controller.booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
        return 'car_instructions_example';
      case VehicleType.bus:
      case VehicleType.miniBus:
        return 'bus_instructions_example';
      case VehicleType.jcb:
        return 'jcb_instructions_example';
      case VehicleType.heavyLorry:
        return 'lorry_instructions_example';
      case VehicleType.tataAce:
        return 'tata_ace_instructions_example';
      case VehicleType.tractor:
        return 'tractor_instructions_example';
      case VehicleType.agriEquipment:
        return 'agri_instructions_example';
    }
  }
}
