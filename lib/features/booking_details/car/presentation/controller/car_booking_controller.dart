// lib/features/booking/car/controllers/car_booking_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking_details/presentation/widget/car_booking_confirm_dialog.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class CarBookingController extends GetxController {
  // Text Controllers
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final promoTextController = TextEditingController();
  final instructionsController = TextEditingController();

  // Booking Model - All Rx for UI updates
  final booking = Rx<CarBookingModel>(
    CarBookingModel(
      vehicleName: '',
      vehicleImagePath: '',
      vehicleNumber: '',
      seatingCapacity: '',
      pricePerKm: '',
      eta: '',
      driverName: 'Sudarsan',
      driverRating: 4.5,
      pickupAddress: '',
      dropAddress: '',
      distance: '',
      time: '33 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'km',
      baseFare: '₹500',
      distanceFare: '₹250',
      distanceFareLabel: 'Distance (10 km × ₹25)',
      platformFee: '₹50',
      gst: '₹40',
      totalEstimate: '₹840',
      acService: false,
      childSeat: false,
      musicSystem: false,
      extraLuggage: false,
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

    // Read arguments from CarVehicleDetailScreen
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    // Calculate distance fare based on base price and extra km charge
    final basePrice = args['basePrice'] ?? 3500.0;
    final extraKmCharge = args['extraKmCharge'] ?? 12.0;
    final distance = 10; // Default distance in km
    final distanceFareValue = distance * extraKmCharge;

    booking.value = CarBookingModel(
      vehicleName: args['vehicleName'] ?? 'Toyota Innova Crysta',
      vehicleImagePath: args['imagePath'] ?? '',
      vehicleNumber: args['vehicleNumber'] ?? 'TN 22 AB 4589',
      seatingCapacity: args['seatingCapacity'] ?? '7+1 Seats',
      pricePerKm: '${args['fare'] ?? '40'}/km',
      eta: 'ETA: 15 mins',
      driverName: 'Sudarsan',
      driverRating: 4.5,
      pickupAddress: '',
      dropAddress: '',
      distance: '10 km',
      time: '33 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'km',
      baseFare: '₹${basePrice.toStringAsFixed(0)}',
      distanceFare: '₹${distanceFareValue.toStringAsFixed(0)}',
      distanceFareLabel:
          'Distance (10 km × ₹${extraKmCharge.toStringAsFixed(0)})',
      platformFee: '₹50',
      gst: '₹40',
      totalEstimate:
          '₹${(basePrice + distanceFareValue + 50 + 40).toStringAsFixed(0)}',
      acService: false,
      childSeat: false,
      musicSystem: false,
      extraLuggage: false,
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
  void toggleAcService(bool val) {
    booking.update((b) {
      b?.acService = val;
    });
    _updateFare();
  }

  void toggleChildSeat(bool val) {
    booking.update((b) {
      b?.childSeat = val;
    });
    _updateFare();
  }

  void toggleMusicSystem(bool val) {
    booking.update((b) {
      b?.musicSystem = val;
    });
    _updateFare();
  }

  void toggleExtraLuggage(bool val) {
    booking.update((b) {
      b?.extraLuggage = val;
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

    // Add service charges
    double additionalCharges = 0;
    if (b.acService) additionalCharges += 200;
    if (b.childSeat) additionalCharges += 150;
    if (b.musicSystem) additionalCharges += 100;
    if (b.extraLuggage) additionalCharges += 200;

    // Platform fee and GST
    double platformFee = 50;
    double gst = 40;

    double total =
        baseFare + distanceFare + additionalCharges + platformFee + gst;

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
    if (code == 'CAR50') {
      booking.update((b) {
        b?.promoCode = code;
        b?.promoApplied = true;
        b?.promoMessage = '🎉 Get ₹50 off on car booking!';
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
    AppSnackbar.warning('Calling driver...');
  }

  void onConfirmBooking() {
    // Validate required fields
    // if (pickupController.text.isEmpty) {
    //   AppSnackbar.error('Please enter pickup location');
    //   return;
    // }
    // if (dropController.text.isEmpty) {
    //   AppSnackbar.error('Please enter drop location');
    //   return;
    // }

    showCarBookingConfirmedDialog(
      bookingId:
          '#CAR${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
      onViewBooking: () {
        Get.back(); // close dialog
        final homeController = Get.find<HomeController>();
        homeController.currentNavIndex.value = 2; // Navigate to bookings tab
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

// ── Car Booking Model ─────────────────────────────────────────────────────
class CarBookingModel {
  String vehicleName;
  String vehicleImagePath;
  String vehicleNumber;
  String seatingCapacity;
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
  String platformFee;
  String gst;
  String totalEstimate;

  // Additional Services
  bool acService;
  bool childSeat;
  bool musicSystem;
  bool extraLuggage;

  // Promo
  String promoCode;
  bool promoApplied;
  String promoMessage;

  // Payment
  String selectedPayment;

  CarBookingModel({
    required this.vehicleName,
    required this.vehicleImagePath,
    required this.vehicleNumber,
    required this.seatingCapacity,
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
    required this.platformFee,
    required this.gst,
    required this.totalEstimate,
    required this.acService,
    required this.childSeat,
    required this.musicSystem,
    required this.extraLuggage,
    required this.promoCode,
    required this.promoApplied,
    required this.promoMessage,
    required this.selectedPayment,
  });
}
