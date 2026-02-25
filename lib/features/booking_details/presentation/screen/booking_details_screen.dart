import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/booking_details/presentation/controller/booking_details_controller.dart';
import 'package:userapp/features/booking_details/presentation/widget/booking_details_model_widget.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/utils/commons/textfield/b_textfiled.dart';

class BookingDetailsScreen extends GetView<BookingDetailsController> {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.put(LanguageController());
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.secondary,
              size: 18.sp,
            ),
          ),
          title: BText(
            text: 'booking_details',
            fontSize: responsiveFont(en: 16.sp, ta: 12.sp),
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.secondary,
            isLocalized: true,
          ),
          actions: [
            Obx(
              () => IconButton(
                icon: Icon(
                  langController.currentLocale.value.languageCode == 'en'
                      ? Icons.language
                      : Icons.translate,
                  color: theme.colorScheme.secondary,
                ),
                onPressed: () => langController.toggleLanguage(),
              ),
            ),
          ],
        ),
        // ── Pass context into body builder so pickers work ────────────────
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
                          _buildVehicleCard(theme, b),
                          Gap(16.h),

                          _buildSectionTitle(theme, 'trip_details'),
                          Gap(10.h),
                          _buildTripDetailsCard(theme, b),
                          Gap(16.h),

                          _buildSectionTitle(theme, 'schedule_booking'),
                          Gap(10.h),
                          _buildScheduleCard(ctx, theme, b),
                          Gap(16.h),

                          _buildSectionTitle(theme, 'driver_details'),
                          Gap(10.h),
                          _buildDriverCard(theme, b),
                          Gap(16.h),

                          _buildKmHourToggle(theme, b),
                          Gap(16.h),

                          _buildSectionTitle(theme, 'additional_services'),
                          Gap(10.h),
                          _buildAdditionalServicesCard(theme, b),
                          Gap(16.h),

                          _buildSectionTitle(theme, 'special_instructions'),
                          Gap(10.h),
                          _buildInstructionsCard(theme),
                          Gap(16.h),

                          _buildSectionTitle(theme, 'estimated_fare'),
                          Gap(10.h),
                          _buildFareCard(theme, b),
                          Gap(16.h),

                          _buildSectionTitle(theme, 'apply_promo_code'),
                          Gap(10.h),
                          _buildPromoCard(theme, b),
                          Gap(16.h),

                          _buildSectionTitle(theme, 'payment_method'),
                          Gap(10.h),
                          _buildPaymentCard(theme, b),
                          Gap(16.h),

                          _buildSectionTitle(theme, 'safety_assurance'),
                          Gap(10.h),
                          _buildSafetyCard(theme),
                          Gap(24.h),
                        ],
                      ),
                    ),
                  ),
                  _buildConfirmButton(theme),
                ],
              );
            });
          },
        ),
      ),
    );
  }

  // ── Section Title ─────────────────────────────────────────────────────────

  Widget _buildSectionTitle(ThemeData theme, String key) {
    return BText(
      text: key,
      fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
      isLocalized: true,
    );
  }

  // ── Vehicle Card ──────────────────────────────────────────────────────────

  Widget _buildVehicleCard(ThemeData theme, BookingDetailsModel b) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: _cardDecoration(theme),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 72.w,
              height: 62.h,
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              child: b.vehicleImagePath.isNotEmpty
                  ? Image.asset(
                      b.vehicleImagePath,
                      width: 72.w,
                      height: 62.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.local_shipping_rounded,
                        color: theme.colorScheme.primary,
                        size: 36.sp,
                      ),
                    )
                  : Icon(
                      Icons.local_shipping_rounded,
                      color: theme.colorScheme.primary,
                      size: 36.sp,
                    ),
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText(
                  text: b.vehicleName,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  isLocalized: false,
                ),
                Gap(4.h),
                BText(
                  text: '${b.pricePerKm} • ${b.eta}',
                  fontSize: 11.sp,
                  color: theme.dividerColor,
                  isLocalized: false,
                ),
                Gap(2.h),
                BText(
                  text: b.capacity,
                  fontSize: 11.sp,
                  color: theme.dividerColor,
                  isLocalized: false,
                ),
                Gap(4.h),
                Row(
                  children: [
                    BText(
                      text: b.driverName,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      isLocalized: false,
                    ),
                    Gap(6.w),
                    Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFFFC107),
                      size: 14.sp,
                    ),
                    Gap(2.w),
                    BText(
                      text: b.driverRating.toString(),
                      fontSize: 11.sp,
                      color: theme.dividerColor,
                      isLocalized: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Trip Details Card ─────────────────────────────────────────────────────

  Widget _buildTripDetailsCard(ThemeData theme, BookingDetailsModel b) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: _cardDecoration(theme),
      child: Column(
        children: [
          BTextField(
            controller: controller.pickupController,
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
            controller: controller.dropController,
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
                child: _infoBox(
                  theme,
                  label: 'distance',
                  value: b.distance,
                  valueColor: theme.colorScheme.primary,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: _infoBox(
                  theme,
                  label: 'time',
                  value: b.time,
                  valueColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Schedule Booking Card ─────────────────────────────────────────────────
  // FIX: BuildContext passed directly — showDatePicker / showTimePicker work

  Widget _buildScheduleCard(
    BuildContext context,
    ThemeData theme,
    BookingDetailsModel b,
  ) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: _cardDecoration(theme),
      child: Column(
        children: [
          // Book Now / Schedule Later
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleBookNow(true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: b.isBookNow
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: b.isBookNow
                            ? theme.colorScheme.primary
                            : theme.dividerColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: b.isBookNow
                              ? AppTheme.red
                              : theme.dividerColor,
                          size: 16.sp,
                        ),
                        Gap(6.w),
                        BText(
                          text: (Get.locale?.languageCode ?? 'en') == 'en'
                              ? 'book_now'
                              : 'book_n',
                          fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                          fontWeight: FontWeight.w600,
                          color: b.isBookNow
                              ? theme.colorScheme.onSurface
                              : theme.dividerColor,
                          isLocalized: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.toggleBookNow(false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: !b.isBookNow
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: !b.isBookNow
                            ? theme.colorScheme.primary
                            : theme.dividerColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: !b.isBookNow
                              ? theme.colorScheme.primary
                              : theme.dividerColor,
                          size: 16.sp,
                        ),
                        Gap(6.w),
                        BText(
                          text: 'schedule_later',
                          fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                          fontWeight: FontWeight.w600,
                          color: !b.isBookNow
                              ? theme.colorScheme.onSurface
                              : theme.dividerColor,
                          isLocalized: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(14.h),

          // Date & Time — native Flutter pickers with real context
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final DateTime today = DateTime.now();
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: today,
                      firstDate: today,
                      lastDate: DateTime(today.year + 1, 12, 31),
                      builder: (ctx, child) => Theme(
                        data: Theme.of(
                          ctx,
                        ).copyWith(colorScheme: Theme.of(ctx).colorScheme),
                        child: child!,
                      ),
                    );
                    if (picked != null) controller.onDateSelected(picked);
                  },
                  child: Obx(
                    () => _pickerBox(
                      theme,
                      value: controller.booking.value.scheduleDate,
                      icon: Icons.calendar_month_rounded,
                    ),
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 14, minute: 30),
                      builder: (ctx, child) => Theme(
                        data: Theme.of(
                          ctx,
                        ).copyWith(colorScheme: Theme.of(ctx).colorScheme),
                        child: child!,
                      ),
                    );
                    if (picked != null) controller.onTimeSelected(picked);
                  },
                  child: Obx(
                    () => _pickerBox(
                      theme,
                      value: controller.booking.value.scheduleTime,
                      icon: Icons.access_time_rounded,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pickerBox(
    ThemeData theme, {
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: BText(
              text: value,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              isLocalized: false,
            ),
          ),
          Icon(icon, color: theme.colorScheme.primary, size: 18.sp),
        ],
      ),
    );
  }

  // ── Driver Details Card ───────────────────────────────────────────────────

  Widget _buildDriverCard(ThemeData theme, BookingDetailsModel b) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: _cardDecoration(theme),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: theme.colorScheme.primary,
                  size: 28.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BText(
                      text: b.driverName,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      isLocalized: false,
                    ),
                    Gap(3.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFC107),
                          size: 13.sp,
                        ),
                        Gap(3.w),
                        Expanded(
                          child: BText(
                            text:
                                '${b.driverRating} ${'rating'.tr} • ${'verified_driver'.tr}',
                            fontSize: 11.sp,
                            color: theme.dividerColor,
                            isLocalized: false,
                          ),
                        ),
                      ],
                    ),
                    Gap(2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: theme.dividerColor,
                          size: 13.sp,
                        ),
                        Gap(3.w),
                        BText(
                          text: '5 ${'years_experience'.tr}',
                          fontSize: 11.sp,
                          color: theme.dividerColor,
                          isLocalized: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(14.h),
          GestureDetector(
            onTap: controller.onCallDriver,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call_rounded,
                    color: theme.colorScheme.onSurface,
                    size: 16.sp,
                  ),
                  Gap(6.w),
                  BText(
                    text: 'call_driver',
                    fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    isLocalized: true,
                  ),
                ],
              ),
            ),
          ),
          Gap(10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: BText(
                text: 'TN 02 AB 8574',
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                isLocalized: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── KM / Hour Based Toggle ────────────────────────────────────────────────
  // FIX: active = filled purple, inactive = outline — with AnimatedContainer

  Widget _buildKmHourToggle(ThemeData theme, BookingDetailsModel b) {
    return Container(
      decoration: _cardDecoration(theme),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: _rateTypeButton(theme, b, label: 'km_based', type: 'km'),
            ),
            Gap(12.w),
            Expanded(
              child: _rateTypeButton(
                theme,
                b,
                label: 'hour_based',
                type: 'hour',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rateTypeButton(
    ThemeData theme,
    BookingDetailsModel b, {
    required String label,
    required String type,
  }) {
    final isSelected = b.selectedRateType == type;
    return GestureDetector(
      onTap: () => controller.selectRateType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.colorScheme.primary, width: 1.5),
        ),
        child: Center(
          child: BText(
            text: label,
            fontSize: responsiveFont(en: 14.sp, ta: 11.sp),
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : theme.colorScheme.primary,
            isLocalized: true,
          ),
        ),
      ),
    );
  }

  // ── Additional Services ───────────────────────────────────────────────────

  Widget _buildAdditionalServicesCard(ThemeData theme, BookingDetailsModel b) {
    return Container(
      decoration: _cardDecoration(theme),
      child: Column(
        children: [
          _buildServiceRow(
            theme: theme,
            labelKey: 'add_loading_helper',
            price: '+₹300',
            value: b.addLoadingHelper,
            onChanged: controller.toggleLoadingHelper,
            isFirst: true,
          ),
          _buildServiceDivider(theme),
          _buildServiceRow(
            theme: theme,
            labelKey: 'add_unloading_helper',
            price: '+₹300',
            value: b.addUnloadingHelper,
            onChanged: controller.toggleUnloadingHelper,
          ),
          _buildServiceDivider(theme),
          _buildServiceRow(
            theme: theme,
            labelKey: 'insurance_coverage',
            price: '+₹150',
            value: b.insuranceCoverage,
            onChanged: controller.toggleInsurance,
          ),
          _buildServiceDivider(theme),
          _buildServiceRow(
            theme: theme,
            labelKey: 'return_trip_required',
            price: 'discuss',
            value: b.returnTripRequired,
            onChanged: controller.toggleReturnTrip,
            isPriceColored: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow({
    required ThemeData theme,
    required String labelKey,
    required String price,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isFirst = false,
    bool isLast = false,
    bool isPriceColored = false,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: value ? theme.colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: value
                      ? theme.colorScheme.primary
                      : theme.dividerColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: value
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 13.sp)
                  : const SizedBox.shrink(),
            ),
            Gap(12.w),
            Expanded(
              child: BText(
                text: labelKey,
                fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
                isLocalized: true,
              ),
            ),
            BText(
              text: price,
              fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
              fontWeight: FontWeight.w600,
              color: isPriceColored
                  ? theme.colorScheme.primary
                  : AppTheme.green,
              isLocalized: isPriceColored,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDivider(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Divider(
        color: theme.dividerColor.withValues(alpha: 0.15),
        height: 1,
      ),
    );
  }

  // ── Special Instructions ──────────────────────────────────────────────────
  // FIX: white card wrapping BTextField + info hint line at bottom

  Widget _buildInstructionsCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: _cardDecoration(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BTextField(
            controller: controller.instructionsController,
            labelText: 'special_instructions',
            hintText: 'instructions_hint',
            isLocalized: true,
            maxLines: 4,
          ),
          Gap(8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 13.sp,
                color: theme.dividerColor,
              ),
              Gap(4.w),
              Expanded(
                child: BText(
                  text: 'instructions_example',
                  fontSize: 11.sp,
                  color: theme.dividerColor,
                  isLocalized: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Estimated Fare ────────────────────────────────────────────────────────

  Widget _buildFareCard(ThemeData theme, BookingDetailsModel b) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: _cardDecoration(theme),
      child: Column(
        children: [
          _buildFareRow(theme, 'base_fare', b.baseFare),
          Gap(8.h),
          _buildFareRow(
            theme,
            b.distanceFareLabel,
            b.distanceFare,
            isLocalized: false,
          ),
          Gap(8.h),
          _buildFareRow(theme, 'platform_fee', b.platformFee),
          Gap(8.h),
          _buildFareRow(theme, 'gst', b.gst),
          Gap(10.h),
          Divider(color: theme.dividerColor.withValues(alpha: 0.2)),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BText(
                text: 'total_estimate',
                fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                isLocalized: true,
              ),
              BText(
                text: b.totalEstimate,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                isLocalized: false,
              ),
            ],
          ),
          Gap(12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFFF8F00),
                  size: 16,
                ),
                Gap(8.w),
                Expanded(
                  child: BText(
                    text: 'fare_note',
                    fontSize: 11.sp,
                    color: const Color(0xFF7B5800),
                    isLocalized: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareRow(
    ThemeData theme,
    String label,
    String value, {
    bool isLocalized = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isLocalized
            ? BText(
                text: label,
                fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                color: theme.dividerColor,
                isLocalized: true,
              )
            : Text(
                label,
                style: TextStyle(fontSize: 13.sp, color: theme.dividerColor),
              ),
        BText(
          text: value,
          fontSize: 13.sp,
          color: theme.colorScheme.onSurface,
          isLocalized: false,
        ),
      ],
    );
  }

  // ── Apply Promo Code ──────────────────────────────────────────────────────
  // FIX: wrapped in white card same as all other sections

  Widget _buildPromoCard(ThemeData theme, BookingDetailsModel b) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: _cardDecoration(theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  // padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.05),
                    // border: Border.all(
                    //   color: b.promoApplied
                    //       ? AppTheme.green
                    //       : theme.dividerColor.withValues(alpha: 0.3),
                    // ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: TextField(
                    controller: controller.promoTextController,
                    textCapitalization: TextCapitalization.characters,
                    style: TextStyle(
                      fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.onSurface,
                    ),

                    decoration: InputDecoration(
                      filled: false,
                      fillColor: Colors.transparent,
                      hintText: 'enter_promo_hint'.tr,
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: theme.dividerColor,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0,
                      ),
                      // border: InputBorder.,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 1,
                        ),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                  ),
                ),
              ),
              Gap(10.w),
              GestureDetector(
                onTap: controller.applyPromoCode,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: BText(
                      text: 'apply',
                      fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.secondary,
                      isLocalized: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (b.promoApplied && b.promoMessage.isNotEmpty) ...[
            Gap(10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppTheme.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppTheme.green.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                b.promoMessage,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.greenDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Payment Method ────────────────────────────────────────────────────────

  Widget _buildPaymentCard(ThemeData theme, BookingDetailsModel b) {
    return Container(
      decoration: _cardDecoration(theme),
      child: Column(
        children: controller.paymentOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = b.selectedPayment == option;
          final isLast = index == controller.paymentOptions.length - 1;

          return Column(
            children: [
              GestureDetector(
                onTap: () => controller.selectPayment(option),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 10.w,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      Gap(12.w),
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          controller.paymentIcons[option] ??
                              Icons.payment_rounded,
                          size: 16.sp,
                          color: theme.dividerColor,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Divider(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                    height: 1,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Safety Assurance ──────────────────────────────────────────────────────

  Widget _buildSafetyCard(ThemeData theme) {
    return Row(
      children: [
        _buildSafetyItem(
          theme: theme,
          icon: Icons.verified_rounded,
          iconColor: AppTheme.green,
          bgColor: AppTheme.green.withValues(alpha: 0.12),
          textKey: 'verified_driver',
          fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
        ),

        Gap(12.w),

        _buildSafetyItem(
          theme: theme,
          icon: Icons.headset_mic_rounded,
          iconColor: theme.colorScheme.primary,
          bgColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          textKey: 'support_24_7',
        ),
      ],
    );
  }

  Widget _buildSafetyItem({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String textKey,
    double? fontSize,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        decoration: _cardDecoration(theme),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            Gap(8.h),
            BText(
              text: textKey,
              fontSize: fontSize ?? 12.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              isLocalized: true,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
  // ── Confirm Button ────────────────────────────────────────────────────────

  Widget _buildConfirmButton(ThemeData theme) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BButton(
        text: 'confirm_booking',
        onTap: controller.onConfirmBooking,
        isOutline: false,
      ),
    );
  }

  // ── Info Box ──────────────────────────────────────────────────────────────

  Widget _infoBox(
    ThemeData theme, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          BText(
            text: label,
            fontSize: 10.sp,
            color: theme.dividerColor,
            isLocalized: true,
          ),
          Gap(4.h),
          BText(
            text: value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: valueColor ?? theme.colorScheme.onSurface,
            isLocalized: false,
          ),
        ],
      ),
    );
  }

  // ── Card Decoration ───────────────────────────────────────────────────────

  BoxDecoration _cardDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.colorScheme.secondary,
      borderRadius: BorderRadius.circular(14.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}
