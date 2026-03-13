import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/booking_details/bus/presentation/controller/bus_booking_controller.dart';
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

class BusBookingScreen extends GetView<BusBookingController> {
  const BusBookingScreen({super.key});

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
          title: 'bus_booking_title',
          showLanguageToggle: true,
          showBackButton: true,
        ),
        body: Builder(
          builder: (ctx) {
            return Obx(() {
              final b = controller.booking.value;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BookingVehicleCard(
                            vehicleName: b.vehicleName,
                            vehicleImagePath: b.vehicleImagePath,
                            pricePerKm: b.pricePerKm,
                            eta: b.eta,
                            capacity1: b.seatingCapacity,
                            capacity2: b.busCategory,
                            driverName: b.driverName,
                            driverRating: b.driverRating,
                            vehicleIcon: Icons.directions_bus_rounded,
                          ),
                          Gap(16.h),

                          const BookingSectionTitle(titleKey: 'trip_details'),
                          Gap(10.h),
                          BookingTripDetailsCard(
                            pickupController: controller.pickupController,
                            dropController: controller.dropController,
                            distance: b.distance,
                            time: b.time,
                          ),
                          Gap(16.h),

                          const BookingSectionTitle(
                            titleKey: 'schedule_booking',
                          ),
                          Gap(10.h),
                          BookingScheduleCard(
                            isBookNow: b.isBookNow,
                            scheduleDate: b.scheduleDate,
                            scheduleTime: b.scheduleTime,
                            onToggleBookNow: controller.toggleBookNow,
                            onDateSelected: controller.onDateSelected,
                            onTimeSelected: controller.onTimeSelected,
                          ),
                          Gap(16.h),

                          const BookingSectionTitle(titleKey: 'driver_details'),
                          Gap(10.h),
                          BookingDriverCard(
                            driverName: b.driverName,
                            driverRating: b.driverRating,
                            vehicleNumber: b.vehicleNumber,
                            experience: '7 ${'years_experience'.tr}',
                            onCallDriver: controller.onCallDriver,
                          ),
                          Gap(16.h),

                          BookingRateTypeToggle(
                            options: [
                              RateTypeOption(type: 'km', labelKey: 'km_based'),
                              RateTypeOption(type: 'day', labelKey: 'per_day'),
                              RateTypeOption(
                                type: 'hour',
                                labelKey: 'per_hour',
                              ),
                            ],
                            selectedType: b.selectedRateType,
                            onTypeSelected: controller.selectRateType,
                            crossAxisCount: 3,
                          ),
                          Gap(16.h),

                          const BookingSectionTitle(
                            titleKey: 'additional_services',
                          ),
                          Gap(10.h),
                          Container(
                            decoration: BookingCardDecoration(theme: theme),
                            child: Column(
                              children: [
                                BookingServiceRow(
                                  labelKey: 'tour_guide',
                                  price: '+₹500',
                                  value: b.tourGuide,
                                  onChanged: controller.toggleTourGuide,
                                  isFirst: true,
                                ),
                                BookingServiceDivider(theme: theme),
                                BookingServiceRow(
                                  labelKey: 'catering',
                                  price: '+₹300',
                                  value: b.catering,
                                  onChanged: controller.toggleCatering,
                                ),
                                BookingServiceDivider(theme: theme),
                                BookingServiceRow(
                                  labelKey: 'extra_luggage',
                                  price: '+₹200',
                                  value: b.extraLuggage,
                                  onChanged: controller.toggleExtraLuggage,
                                ),
                                BookingServiceDivider(theme: theme),
                                BookingServiceRow(
                                  labelKey: 'photography',
                                  price: '+₹400',
                                  value: b.photography,
                                  onChanged: controller.togglePhotography,
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),
                          Gap(16.h),

                          const BookingSectionTitle(
                            titleKey: 'special_instructions',
                          ),
                          Gap(10.h),
                          BookingInstructionsCard(
                            controller: controller.instructionsController,
                            hintTextKey: 'bus_instructions_hint',
                            exampleTextKey: 'bus_instructions_example',
                          ),
                          Gap(16.h),

                          const BookingSectionTitle(titleKey: 'estimated_fare'),
                          Gap(10.h),
                          BookingFareCard(
                            fareRows: [
                              FareRowItem(
                                label: 'base_fare',
                                value: b.baseFare,
                              ),
                              FareRowItem(
                                label: b.distanceFareLabel,
                                value: b.distanceFare,
                                isLocalized: false,
                              ),
                              FareRowItem(
                                label: 'driver_bata',
                                value: b.driverBata,
                              ),
                              FareRowItem(
                                label: 'platform_fee',
                                value: b.platformFee,
                              ),
                              FareRowItem(label: 'gst', value: b.gst),
                            ],
                            totalEstimate: b.totalEstimate,
                          ),
                          Gap(16.h),

                          const BookingSectionTitle(
                            titleKey: 'apply_promo_code',
                          ),
                          Gap(10.h),
                          BookingPromoCard(
                            controller: controller.promoTextController,
                            promoApplied: b.promoApplied,
                            promoMessage: b.promoMessage,
                            onApply: controller.applyPromoCode,
                          ),
                          Gap(16.h),

                          const BookingSectionTitle(titleKey: 'payment_method'),
                          Gap(10.h),
                          BookingPaymentCard(
                            options: controller.paymentOptions
                                .asMap()
                                .entries
                                .map((entry) {
                                  return PaymentOption(
                                    type: entry.value,
                                    label: entry.value,
                                    icon:
                                        controller.paymentIcons[entry.value] ??
                                        Icons.payment_rounded,
                                  );
                                })
                                .toList(),
                            selectedPayment: b.selectedPayment,
                            onPaymentSelected: controller.selectPayment,
                          ),
                          Gap(16.h),

                          const BookingSectionTitle(
                            titleKey: 'safety_assurance',
                          ),
                          Gap(10.h),
                          BookingSafetyCard(
                            items: [
                              SafetyItem(
                                icon: Icons.verified_rounded,
                                iconColor: AppTheme.green,
                                bgColor: AppTheme.green.withValues(alpha: 0.12),
                                labelKey: 'verified_driver',
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
                  BookingConfirmButton(onConfirm: controller.onConfirmBooking),
                ],
              );
            });
          },
        ),
      ),
    );
  }
}
