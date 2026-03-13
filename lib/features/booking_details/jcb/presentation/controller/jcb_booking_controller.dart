// lib/features/booking/jcb/controllers/jcb_booking_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking_details/presentation/widget/car_booking_confirm_dialog.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class JcbBookingController extends GetxController {
  // Text Controllers
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final promoTextController = TextEditingController();
  final instructionsController = TextEditingController();

  // Booking Model
  final booking = Rx<JcbBookingModel>(
    JcbBookingModel(
      vehicleName: '',
      vehicleImagePath: '',
      vehicleNumber: '',
      jcbModel: '',
      bucketType: '',
      fuelType: '',
      pricePerHour: '',
      eta: '',
      operatorName: 'Muthu',
      operatorRating: 4.8,
      pickupAddress: '',
      dropAddress: '',
      distance: '',
      time: '45 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'hour',
      baseFare: '₹800',
      distanceFare: '₹0',
      distanceFareLabel: 'Distance (Included)',
      extraHourCharge: '₹200/hr',
      operatorBata: '₹300',
      fuelCharge: 'Included',
      platformFee: '₹50',
      gst: '₹70',
      totalEstimate: '₹1220',
      extraOperator: false,
      nightWork: false,
      rockBreaking: false,
      siteClearance: false,
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

    // Parse values
    final basePriceStr = args['basePrice'] ?? '₹800/hr';
    final basePrice =
        double.tryParse(
          basePriceStr.replaceAll('₹', '').replaceAll('/hr', ''),
        ) ??
        800;
    final extraHourStr = args['extraHourCharge'] ?? '₹200/hr';
    final extraHour =
        double.tryParse(
          extraHourStr.replaceAll('₹', '').replaceAll('/hr', ''),
        ) ??
        200;
    final operatorBataStr = args['operatorBata'] ?? '₹300';
    final operatorBata =
        double.tryParse(operatorBataStr.replaceAll('₹', '')) ?? 300;

    booking.value = JcbBookingModel(
      vehicleName: args['vehicleName'] ?? 'JCB 3DX',
      vehicleImagePath: args['imagePath'] ?? '',
      vehicleNumber: args['vehicleNumber'] ?? 'TN 22 AB 4589',
      jcbModel: args['jcbModel'] ?? 'JCB 3DX',
      bucketType: args['bucketType'] ?? 'Big Bucket',
      fuelType: args['fuelType'] ?? 'Diesel',
      pricePerHour: '₹${args['fare'] ?? '800'}/hr',
      eta: 'ETA: 45 mins',
      operatorName: 'Muthu',
      operatorRating: 4.8,
      pickupAddress: '',
      dropAddress: '',
      distance: '10 km',
      time: '45 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'hour',
      baseFare: '₹${basePrice.toStringAsFixed(0)}',
      distanceFare: '₹0',
      distanceFareLabel: 'Distance (Included)',
      extraHourCharge: '₹${extraHour.toStringAsFixed(0)}/hr',
      operatorBata: '₹${operatorBata.toStringAsFixed(0)}',
      fuelCharge: args['fuelCharge'] ?? 'Included',
      platformFee: '₹50',
      gst: '₹70',
      totalEstimate:
          '₹${(basePrice + operatorBata + 50 + 70).toStringAsFixed(0)}',
      extraOperator: false,
      nightWork: false,
      rockBreaking: false,
      siteClearance: false,
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

  void toggleExtraOperator(bool val) {
    booking.update((b) {
      b?.extraOperator = val;
    });
    _updateFare();
  }

  void toggleNightWork(bool val) {
    booking.update((b) {
      b?.nightWork = val;
    });
    _updateFare();
  }

  void toggleRockBreaking(bool val) {
    booking.update((b) {
      b?.rockBreaking = val;
    });
    _updateFare();
  }

  void toggleSiteClearance(bool val) {
    booking.update((b) {
      b?.siteClearance = val;
    });
    _updateFare();
  }

  void _updateFare() {
    final b = booking.value;

    double baseFare = double.tryParse(b.baseFare.replaceAll('₹', '')) ?? 800;
    double operatorBata =
        double.tryParse(b.operatorBata.replaceAll('₹', '')) ?? 300;

    double additionalCharges = 0;
    if (b.extraOperator) additionalCharges += 500;
    if (b.nightWork) additionalCharges += 300;
    if (b.rockBreaking) additionalCharges += 400;
    if (b.siteClearance) additionalCharges += 250;

    double platformFee = 50;
    double gst = 70;

    double total =
        baseFare + operatorBata + additionalCharges + platformFee + gst;

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
    if (code == 'JCB150') {
      booking.update((b) {
        b?.promoCode = code;
        b?.promoApplied = true;
        b?.promoMessage = '🎉 Get ₹150 off on JCB booking!';
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

  void onCallOperator() => AppSnackbar.success('Calling operator...');

  void onConfirmBooking() {
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
          '#JCB${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
      onViewBooking: () {
        Get.back();
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

class JcbBookingModel {
  String vehicleName;
  String vehicleImagePath;
  String vehicleNumber;
  String jcbModel;
  String bucketType;
  String fuelType;
  String pricePerHour;
  String eta;
  String operatorName;
  double operatorRating;
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
  String extraHourCharge;
  String operatorBata;
  String fuelCharge;
  String platformFee;
  String gst;
  String totalEstimate;
  bool extraOperator;
  bool nightWork;
  bool rockBreaking;
  bool siteClearance;
  String promoCode;
  bool promoApplied;
  String promoMessage;
  String selectedPayment;

  JcbBookingModel({
    required this.vehicleName,
    required this.vehicleImagePath,
    required this.vehicleNumber,
    required this.jcbModel,
    required this.bucketType,
    required this.fuelType,
    required this.pricePerHour,
    required this.eta,
    required this.operatorName,
    required this.operatorRating,
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
    required this.extraHourCharge,
    required this.operatorBata,
    required this.fuelCharge,
    required this.platformFee,
    required this.gst,
    required this.totalEstimate,
    required this.extraOperator,
    required this.nightWork,
    required this.rockBreaking,
    required this.siteClearance,
    required this.promoCode,
    required this.promoApplied,
    required this.promoMessage,
    required this.selectedPayment,
  });
}
