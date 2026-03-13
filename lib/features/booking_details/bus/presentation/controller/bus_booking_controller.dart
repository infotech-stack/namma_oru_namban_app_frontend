// lib/features/booking/bus/controllers/bus_booking_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking_details/presentation/widget/car_booking_confirm_dialog.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class BusBookingController extends GetxController {
  // Text Controllers
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final promoTextController = TextEditingController();
  final instructionsController = TextEditingController();

  // Booking Model
  final booking = Rx<BusBookingModel>(
    BusBookingModel(
      vehicleName: '',
      vehicleImagePath: '',
      vehicleNumber: '',
      busCategory: '',
      seatingCapacity: '',
      pricePerKm: '',
      eta: '',
      driverName: 'Rajesh',
      driverRating: 4.8,
      pickupAddress: '',
      dropAddress: '',
      distance: '',
      time: '45 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'km',
      baseFare: '₹4500',
      distanceFare: '₹450',
      distanceFareLabel: 'Distance (10 km × ₹45)',
      driverBata: '₹300',
      platformFee: '₹50',
      gst: '₹70',
      totalEstimate: '₹5370',
      tourGuide: false,
      catering: false,
      extraLuggage: false,
      photography: false,
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

    final args = Get.arguments as Map<String, dynamic>? ?? {};

    final basePrice = args['basePrice'] ?? 4500.0;
    final pricePerKm = args['pricePerKm'] ?? 45.0;
    final distance = 10;
    final distanceFareValue = distance * pricePerKm;

    booking.value = BusBookingModel(
      vehicleName: args['vehicleName'] ?? 'Semi Sleeper Bus',
      vehicleImagePath: args['imagePath'] ?? '',
      vehicleNumber: args['vehicleNumber'] ?? 'TN 22 AB 4589',
      busCategory: args['busCategory'] ?? 'Semi Sleeper',
      seatingCapacity: args['seatingCapacity'] ?? '38 Seats',
      pricePerKm: '₹${args['fare'] ?? '45'}/km',
      eta: 'ETA: 45 mins',
      driverName: 'Rajesh',
      driverRating: 4.8,
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
      distanceFareLabel: 'Distance (10 km × ₹${pricePerKm.toStringAsFixed(0)})',
      driverBata: '₹${args['driverBata'] ?? 300}',
      platformFee: '₹50',
      gst: '₹70',
      totalEstimate:
          '₹${(basePrice + distanceFareValue + 300 + 50 + 70).toStringAsFixed(0)}',
      tourGuide: false,
      catering: false,
      extraLuggage: false,
      photography: false,
      promoCode: '',
      promoApplied: false,
      promoMessage: '',
      selectedPayment: 'UPI',
    );
  }

  void toggleBookNow(bool val) => booking.update((b) {
    b?.isBookNow = val;
  });

  void onDateSelected(DateTime date) => booking.update((b) {
    b?.scheduleDate = DateFormat('dd-MM-yyyy').format(date);
  });

  void onTimeSelected(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    booking.update((b) {
      b?.scheduleTime = DateFormat('hh:mm a').format(dt);
    });
  }

  void selectRateType(String type) {
    booking.update((b) {
      b?.selectedRateType = type;
    });
    _updateFare();
  }

  void toggleTourGuide(bool val) {
    booking.update((b) {
      b?.tourGuide = val;
    });
    _updateFare();
  }

  void toggleCatering(bool val) {
    booking.update((b) {
      b?.catering = val;
    });
    _updateFare();
  }

  void toggleExtraLuggage(bool val) {
    booking.update((b) {
      b?.extraLuggage = val;
    });
    _updateFare();
  }

  void togglePhotography(bool val) {
    booking.update((b) {
      b?.photography = val;
    });
    _updateFare();
  }

  void _updateFare() {
    final b = booking.value;

    double baseFare = double.tryParse(b.baseFare.replaceAll('₹', '')) ?? 0;
    double distanceFare =
        double.tryParse(b.distanceFare.replaceAll('₹', '')) ?? 0;
    double driverBata =
        double.tryParse(b.driverBata.replaceAll('₹', '')) ?? 300;

    double additionalCharges = 0;
    if (b.tourGuide) additionalCharges += 500;
    if (b.catering) additionalCharges += 300;
    if (b.extraLuggage) additionalCharges += 200;
    if (b.photography) additionalCharges += 400;

    double platformFee = 50;
    double gst = 70;

    double total =
        baseFare +
        distanceFare +
        driverBata +
        additionalCharges +
        platformFee +
        gst;

    booking.update((b) {
      b?.totalEstimate = '₹${total.toStringAsFixed(0)}';
    });
  }

  void applyPromoCode() {
    final code = promoTextController.text.trim().toUpperCase();
    if (code.isEmpty) {
      AppSnackbar.error('enter_promo'.tr);
      return;
    }
    if (code == 'BUS100') {
      booking.update((b) {
        b?.promoCode = code;
        b?.promoApplied = true;
        b?.promoMessage = '🎉 Get ₹100 off on bus booking!';
      });
    } else {
      booking.update((b) {
        b?.promoApplied = false;
        b?.promoMessage = '';
      });
      AppSnackbar.error('promo_invalid_msg'.tr);
    }
  }

  void selectPayment(String method) => booking.update((b) {
    b?.selectedPayment = method;
  });

  void onCallDriver() => AppSnackbar.success('Calling driver...');

  void onConfirmBooking() {
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
          '#BUS${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
      onViewBooking: () {
        Get.back();
        final homeController = Get.find<HomeController>();
        homeController.currentNavIndex.value = 2;
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

class BusBookingModel {
  String vehicleName;
  String vehicleImagePath;
  String vehicleNumber;
  String busCategory;
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
  String driverBata;
  String platformFee;
  String gst;
  String totalEstimate;
  bool tourGuide;
  bool catering;
  bool extraLuggage;
  bool photography;
  String promoCode;
  bool promoApplied;
  String promoMessage;
  String selectedPayment;

  BusBookingModel({
    required this.vehicleName,
    required this.vehicleImagePath,
    required this.vehicleNumber,
    required this.busCategory,
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
    required this.driverBata,
    required this.platformFee,
    required this.gst,
    required this.totalEstimate,
    required this.tourGuide,
    required this.catering,
    required this.extraLuggage,
    required this.photography,
    required this.promoCode,
    required this.promoApplied,
    required this.promoMessage,
    required this.selectedPayment,
  });
}
