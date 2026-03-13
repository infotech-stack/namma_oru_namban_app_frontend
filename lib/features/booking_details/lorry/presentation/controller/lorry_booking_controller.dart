// lib/features/booking/lorry/controllers/lorry_booking_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking_details/presentation/widget/car_booking_confirm_dialog.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class LorryBookingController extends GetxController {
  // Text Controllers
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final promoTextController = TextEditingController();
  final instructionsController = TextEditingController();

  // Booking Model - All Rx for UI updates
  final booking = Rx<LorryBookingModel>(
    LorryBookingModel(
      vehicleName: '',
      vehicleImagePath: '',
      vehicleNumber: '',
      vehicleModel: '',
      loadCapacity: '',
      bodyType: '',
      pricePerKm: '',
      eta: '',
      driverName: 'Kumar',
      driverRating: 4.5,
      pickupAddress: '',
      dropAddress: '',
      distance: '',
      time: '45 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'km',
      baseFare: '₹3500',
      distanceFare: '₹350',
      distanceFareLabel: 'Distance (10 km × ₹35)',
      loadingCharge: '₹500',
      unloadingCharge: '₹500',
      driverBata: '₹300',
      platformFee: '₹50',
      gst: '₹70',
      totalEstimate: '₹4770',
      needLoadingHelper: false,
      needUnloadingHelper: false,
      insuranceCoverage: false,
      returnTripRequired: false,
      promoCode: '',
      promoApplied: false,
      promoMessage: '',
      selectedPayment: 'UPI',
    ),
  );

  // Payment Options
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

  @override
  void onInit() {
    super.onInit();

    // Read arguments from LorryVehicleDetailScreen
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    // Parse values
    final basePrice = args['basePrice'] ?? 3500.0;
    final farePerKm = double.tryParse(args['fare']?.toString() ?? '35') ?? 35.0;
    final distance = 10; // Default distance in km
    final distanceFareValue = distance * farePerKm;

    // Parse loading/unloading charges
    final loadingChargeStr = args['loadingCharge'] ?? '₹500';
    final unloadingChargeStr = args['unloadingCharge'] ?? '₹500';
    final driverBataStr = args['driverBata'] ?? '₹300';

    booking.value = LorryBookingModel(
      vehicleName: args['vehicleName'] ?? 'Tata 407',
      vehicleImagePath: args['imagePath'] ?? '',
      vehicleNumber: args['vehicleNumber'] ?? 'TN 22 AB 4589',
      vehicleModel: args['vehicleModel'] ?? 'Tata 407',
      loadCapacity: args['loadCapacity'] ?? '5 Tons',
      bodyType: args['bodyType'] ?? 'OPEN BODY',
      pricePerKm: '₹${args['fare'] ?? '35'}/km',
      eta: 'ETA: 45 mins',
      driverName: 'Kumar',
      driverRating: 4.5,
      pickupAddress: '',
      dropAddress: '',
      distance: '10 km',
      time: '45 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'km',
      baseFare: '₹${basePrice.toStringAsFixed(0)}',
      distanceFare: '₹${distanceFareValue.toStringAsFixed(0)}',
      distanceFareLabel: 'Distance (10 km × ₹${farePerKm.toStringAsFixed(0)})',
      loadingCharge: loadingChargeStr,
      unloadingCharge: unloadingChargeStr,
      driverBata: driverBataStr,
      platformFee: '₹50',
      gst: '₹70',
      totalEstimate:
          '₹${(basePrice + distanceFareValue + 500 + 500 + 300 + 50 + 70).toStringAsFixed(0)}',
      needLoadingHelper: false,
      needUnloadingHelper: false,
      insuranceCoverage: false,
      returnTripRequired: false,
      promoCode: '',
      promoApplied: false,
      promoMessage: '',
      selectedPayment: 'UPI',
    );

    pickupController.text = booking.value.pickupAddress;
    dropController.text = booking.value.dropAddress;
  }

  // ── Schedule Methods ──────────────────────────────────────────────────────
  void toggleBookNow(bool val) {
    booking.update((b) {
      b?.isBookNow = val;
    });
  }

  void onDateSelected(DateTime date) {
    booking.update((b) {
      b?.scheduleDate = DateFormat('dd-MM-yyyy').format(date);
    });
  }

  void onTimeSelected(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    booking.update((b) {
      b?.scheduleTime = DateFormat('hh:mm a').format(dt);
    });
  }

  // ── Rate Type ────────────────────────────────────────────────────────────
  void selectRateType(String type) {
    booking.update((b) {
      b?.selectedRateType = type;
    });
    _updateFare();
  }

  // ── Additional Services ──────────────────────────────────────────────────
  void toggleLoadingHelper(bool val) {
    booking.update((b) {
      b?.needLoadingHelper = val;
    });
    _updateFare();
  }

  void toggleUnloadingHelper(bool val) {
    booking.update((b) {
      b?.needUnloadingHelper = val;
    });
    _updateFare();
  }

  void toggleInsurance(bool val) {
    booking.update((b) {
      b?.insuranceCoverage = val;
    });
    _updateFare();
  }

  void toggleReturnTrip(bool val) {
    booking.update((b) {
      b?.returnTripRequired = val;
    });
    _updateFare();
  }

  // ── Fare Calculation ────────────────────────────────────────────────────
  void _updateFare() {
    final b = booking.value;

    // Parse base values
    double baseFare = double.tryParse(b.baseFare.replaceAll('₹', '')) ?? 0;
    double distanceFare =
        double.tryParse(b.distanceFare.replaceAll('₹', '')) ?? 0;
    double loadingCharge =
        double.tryParse(b.loadingCharge.replaceAll('₹', '')) ?? 500;
    double unloadingCharge =
        double.tryParse(b.unloadingCharge.replaceAll('₹', '')) ?? 500;
    double driverBata =
        double.tryParse(b.driverBata.replaceAll('₹', '')) ?? 300;

    // Add service charges
    double additionalCharges = 0;
    if (b.needLoadingHelper) additionalCharges += 300;
    if (b.needUnloadingHelper) additionalCharges += 300;
    if (b.insuranceCoverage) additionalCharges += 150;

    // Platform fee and GST
    double platformFee = 50;
    double gst = 70;

    double total =
        baseFare +
        distanceFare +
        loadingCharge +
        unloadingCharge +
        driverBata +
        additionalCharges +
        platformFee +
        gst;

    booking.update((b) {
      b?.totalEstimate = '₹${total.toStringAsFixed(0)}';
    });
  }

  // ── Promo Code ──────────────────────────────────────────────────────────
  void applyPromoCode() {
    final code = promoTextController.text.trim().toUpperCase();
    if (code.isEmpty) {
      AppSnackbar.error('enter_promo'.tr);
      return;
    }
    if (code == 'LORRY100') {
      booking.update((b) {
        b?.promoCode = code;
        b?.promoApplied = true;
        b?.promoMessage = '🎉 Get ₹100 off on lorry booking!';
      });
    } else {
      booking.update((b) {
        b?.promoApplied = false;
        b?.promoMessage = '';
      });
      AppSnackbar.error('promo_invalid_msg'.tr);
    }
  }

  // ── Payment ─────────────────────────────────────────────────────────────
  void selectPayment(String method) {
    booking.update((b) {
      b?.selectedPayment = method;
    });
  }

  // ── Actions ─────────────────────────────────────────────────────────────
  void onCallDriver() {
    AppSnackbar.success('Calling driver...');
  }

  void onConfirmBooking() {
    // Validate required fields
    if (pickupController.text.isEmpty) {
      AppSnackbar.error('Please enter pickup location');
      return;
    }
    if (dropController.text.isEmpty) {
      AppSnackbar.error('Please enter drop location');
      return;
    }

    showCarBookingConfirmedDialog(
      bookingId:
          '#LRY${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
      onViewBooking: () {
        Get.back(); // close dialog
        final homeController = Get.find<HomeController>();
        homeController.currentNavIndex.value = 1; // Navigate to bookings tab
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

// ── Lorry Booking Model ─────────────────────────────────────────────────────
class LorryBookingModel {
  String vehicleName;
  String vehicleImagePath;
  String vehicleNumber;
  String vehicleModel;
  String loadCapacity;
  String bodyType;
  String pricePerKm;
  String eta;
  String driverName;
  double driverRating;
  String pickupAddress;
  String dropAddress;
  String distance;
  String time;
  String scheduleDate;
  String scheduleTime;
  bool isBookNow;
  String selectedRateType;
  String baseFare;
  String distanceFare;
  String distanceFareLabel;
  String loadingCharge;
  String unloadingCharge;
  String driverBata;
  String platformFee;
  String gst;
  String totalEstimate;

  // Additional Services
  bool needLoadingHelper;
  bool needUnloadingHelper;
  bool insuranceCoverage;
  bool returnTripRequired;

  // Promo
  String promoCode;
  bool promoApplied;
  String promoMessage;

  // Payment
  String selectedPayment;

  LorryBookingModel({
    required this.vehicleName,
    required this.vehicleImagePath,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.loadCapacity,
    required this.bodyType,
    required this.pricePerKm,
    required this.eta,
    required this.driverName,
    required this.driverRating,
    required this.pickupAddress,
    required this.dropAddress,
    required this.distance,
    required this.time,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.isBookNow,
    required this.selectedRateType,
    required this.baseFare,
    required this.distanceFare,
    required this.distanceFareLabel,
    required this.loadingCharge,
    required this.unloadingCharge,
    required this.driverBata,
    required this.platformFee,
    required this.gst,
    required this.totalEstimate,
    required this.needLoadingHelper,
    required this.needUnloadingHelper,
    required this.insuranceCoverage,
    required this.returnTripRequired,
    required this.promoCode,
    required this.promoApplied,
    required this.promoMessage,
    required this.selectedPayment,
  });
}
