// lib/features/booking/tractor/controllers/tractor_booking_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking_details/presentation/widget/car_booking_confirm_dialog.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class TractorBookingController extends GetxController {
  // Text Controllers
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final promoTextController = TextEditingController();
  final instructionsController = TextEditingController();

  // Booking Model
  final booking = Rx<TractorBookingModel>(
    TractorBookingModel(
      vehicleName: '',
      vehicleImagePath: '',
      vehicleNumber: '',
      horsePower: '',
      attachment: '',
      pricePerHour: '',
      eta: '',
      operatorName: 'Velmurugan',
      operatorRating: 4.8,
      pickupAddress: '',
      dropAddress: '',
      distance: '',
      time: '60 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'hour',
      baseFare: '₹700',
      distanceFare: '₹0',
      distanceFareLabel: 'Distance (Included)',
      operatorCharge: '₹300',
      platformFee: '₹30',
      gst: '₹40',
      totalEstimate: '₹1070',
      attachmentRental: false,
      fuelSupply: false,
      nightWork: false,
      transport: false,
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
    final basePriceStr = args['basePrice'] ?? '₹700/hr';
    final basePrice =
        double.tryParse(
          basePriceStr.replaceAll('₹', '').replaceAll('/hr', ''),
        ) ??
        700;
    final operatorChargeStr = args['operatorCharge'] ?? '₹300';
    final operatorCharge =
        double.tryParse(operatorChargeStr.replaceAll('₹', '')) ?? 300;

    booking.value = TractorBookingModel(
      vehicleName: args['vehicleName'] ?? 'Mahindra 475',
      vehicleImagePath: args['imagePath'] ?? '',
      vehicleNumber: args['vehicleNumber'] ?? 'TN 22 AB 4589',
      horsePower: args['horsePower'] ?? '45 HP',
      attachment: args['attachment'] ?? 'Rotavator',
      pricePerHour: '₹${args['fare'] ?? '700'}/hr',
      eta: 'ETA: 60 mins',
      operatorName: 'Velmurugan',
      operatorRating: 4.8,
      pickupAddress: '',
      dropAddress: '',
      distance: 'Farm area',
      time: '60 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'hour',
      baseFare: '₹${basePrice.toStringAsFixed(0)}',
      distanceFare: '₹0',
      distanceFareLabel: 'Distance (Included)',
      operatorCharge: '₹${operatorCharge.toStringAsFixed(0)}',
      platformFee: '₹30',
      gst: '₹40',
      totalEstimate:
          '₹${(basePrice + operatorCharge + 30 + 40).toStringAsFixed(0)}',
      attachmentRental: false,
      fuelSupply: false,
      nightWork: false,
      transport: false,
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

  void toggleAttachmentRental(bool val) {
    booking.update((b) {
      b?.attachmentRental = val;
    });
    _updateFare();
  }

  void toggleFuelSupply(bool val) {
    booking.update((b) {
      b?.fuelSupply = val;
    });
    _updateFare();
  }

  void toggleNightWork(bool val) {
    booking.update((b) {
      b?.nightWork = val;
    });
    _updateFare();
  }

  void toggleTransport(bool val) {
    booking.update((b) {
      b?.transport = val;
    });
    _updateFare();
  }

  void _updateFare() {
    final b = booking.value;

    double baseFare = double.tryParse(b.baseFare.replaceAll('₹', '')) ?? 700;
    double operatorCharge =
        double.tryParse(b.operatorCharge.replaceAll('₹', '')) ?? 300;

    double additionalCharges = 0;
    if (b.attachmentRental) additionalCharges += 200;
    if (b.fuelSupply) additionalCharges += 300;
    if (b.nightWork) additionalCharges += 400;
    if (b.transport) additionalCharges += 500;

    double platformFee = 30;
    double gst = 40;

    double total =
        baseFare + operatorCharge + additionalCharges + platformFee + gst;

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
    if (code == 'TRACTOR100') {
      booking.update((b) {
        b?.promoCode = code;
        b?.promoApplied = true;
        b?.promoMessage = '🎉 Get ₹100 off on tractor booking!';
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

    showCarBookingConfirmedDialog(
      bookingId:
          '#TRC${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
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

class TractorBookingModel {
  String vehicleName;
  String vehicleImagePath;
  String vehicleNumber;
  String horsePower;
  String attachment;
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
  String operatorCharge;
  String platformFee;
  String gst;
  String totalEstimate;
  bool attachmentRental;
  bool fuelSupply;
  bool nightWork;
  bool transport;
  String promoCode;
  bool promoApplied;
  String promoMessage;
  String selectedPayment;

  TractorBookingModel({
    required this.vehicleName,
    required this.vehicleImagePath,
    required this.vehicleNumber,
    required this.horsePower,
    required this.attachment,
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
    required this.operatorCharge,
    required this.platformFee,
    required this.gst,
    required this.totalEstimate,
    required this.attachmentRental,
    required this.fuelSupply,
    required this.nightWork,
    required this.transport,
    required this.promoCode,
    required this.promoApplied,
    required this.promoMessage,
    required this.selectedPayment,
  });
}
