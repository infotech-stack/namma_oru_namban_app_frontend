import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking_details/presentation/widget/booking_confirm_dialog.dart';
import 'package:userapp/features/booking_details/presentation/widget/booking_details_model_widget.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class BookingDetailsController extends GetxController {
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final promoTextController = TextEditingController();
  final instructionsController = TextEditingController();

  // Initialised with empty defaults — fully overwritten in onInit from route arguments
  final booking = Rx<BookingDetailsModel>(
    BookingDetailsModel(
      vehicleName: '',
      vehicleImagePath: '',
      pricePerKm: '',
      eta: '',
      capacity: '',
      driverName: 'Sudarsan',
      driverRating: 4.5,
      pickupAddress: '',
      dropAddress: '',
      distance: '',
      time: '33 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      selectedRateType: 'km',
      baseFare: '₹500',
      distanceFare: '₹250',
      distanceFareLabel: 'Distance (10 km × ₹25)',
      platformFee: '₹50',
      gst: '₹40',
      totalEstimate: '₹840',
    ),
  );

  @override
  void onInit() {
    super.onInit();

    // ── Read arguments from Get.toNamed(Routes.bookingDetails, arguments: {...}) ──
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    booking.value = BookingDetailsModel(
      vehicleName: args['name'] ?? 'Container Truck',
      vehicleImagePath: args['imagePath'] ?? '',
      pricePerKm: args['fare'] ?? '₹25/km',
      eta: 'ETA: ${args['eta'] ?? '18 mins'}',
      capacity: args['capacity'] ?? 'Capacity: 10 Tons',
      driverName: 'Sudarsan',
      driverRating: double.tryParse(args['rating']?.toString() ?? '') ?? 4.5,
      pickupAddress: '',
      dropAddress: '',
      distance: '${args['distance'] ?? '0'} km',
      time: '33 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      selectedRateType: 'km',
      baseFare: '₹500',
      distanceFare: '₹250',
      distanceFareLabel: 'Distance (10 km × ${args['fare'] ?? '₹25'})',
      platformFee: '₹50',
      gst: '₹40',
      totalEstimate: '₹840',
    );

    pickupController.text = booking.value.pickupAddress;
    dropController.text = booking.value.dropAddress;
  }

  final List<String> paymentOptions = [
    'UPI',
    'Debit / Credit Card',
    'Net Banking',
    'Wallet',
    'Cash Payment',
  ];

  final Map<String, IconData> paymentIcons = {
    'UPI': Icons.account_balance_wallet_outlined,
    'Debit / Credit Card': Icons.credit_card_rounded,
    'Net Banking': Icons.account_balance_rounded,
    'Wallet': Icons.wallet_rounded,
    'Cash Payment': Icons.money_rounded,
  };

  // ── Schedule ──────────────────────────────────────────────────────────────

  void toggleBookNow(bool val) =>
      booking.value = booking.value.copyWith(isBookNow: val);

  void onDateSelected(DateTime date) {
    booking.value = booking.value.copyWith(
      scheduleDate: DateFormat('dd-MM-yyyy').format(date),
    );
  }

  void onTimeSelected(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    booking.value = booking.value.copyWith(
      scheduleTime: DateFormat('hh:mm a').format(dt),
    );
  }

  // ── KM / Hour Based ───────────────────────────────────────────────────────

  void selectRateType(String type) =>
      booking.value = booking.value.copyWith(selectedRateType: type);

  // ── Additional Services ───────────────────────────────────────────────────

  void toggleLoadingHelper(bool val) =>
      booking.value = booking.value.copyWith(addLoadingHelper: val);

  void toggleUnloadingHelper(bool val) =>
      booking.value = booking.value.copyWith(addUnloadingHelper: val);

  void toggleInsurance(bool val) =>
      booking.value = booking.value.copyWith(insuranceCoverage: val);

  void toggleReturnTrip(bool val) =>
      booking.value = booking.value.copyWith(returnTripRequired: val);

  // ── Promo ─────────────────────────────────────────────────────────────────

  void applyPromoCode() {
    final code = promoTextController.text.trim().toUpperCase();
    if (code.isEmpty) {
      // Get.snackbar(
      //   'promo_error'.tr,
      //   'enter_promo'.tr,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      AppSnackbar.error('enter_promo'.tr);
      return;
    }
    if (code == 'CVXVC') {
      booking.value = booking.value.copyWith(
        promoCode: code,
        promoApplied: true,
        promoMessage: '🎉 Get ₹100 off on first booking!',
      );
    } else {
      booking.value = booking.value.copyWith(
        promoApplied: false,
        promoMessage: '',
      );
      // Get.snackbar(
      //   'promo_invalid'.tr,
      //   'promo_invalid_msg'.tr,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      AppSnackbar.error('promo_invalid_msg'.tr);
    }
  }

  // ── Payment ───────────────────────────────────────────────────────────────

  void selectPayment(String method) =>
      booking.value = booking.value.copyWith(selectedPayment: method);

  // ── Actions ───────────────────────────────────────────────────────────────

  void onCallDriver() {
    // TODO: launch phone call e.g. url_launcher
  }

  void onConfirmBooking() {
    showBookingConfirmedDialog(
      bookingId: '#BK20260217',
      onViewBooking: () {
        Get.back(); // close dialog
        final homeController = Get.find<HomeController>();
        homeController.currentNavIndex.value = 1;

        Get.until((route) => route.settings.name == Routes.wrapper);
      },
    );
  }

  @override
  void onClose() {
    pickupController.dispose();
    dropController.dispose();
    promoTextController.dispose();
    instructionsController.dispose();
    super.onClose();
  }
}
