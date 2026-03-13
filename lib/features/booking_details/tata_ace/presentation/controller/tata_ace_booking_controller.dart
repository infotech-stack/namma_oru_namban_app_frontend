// lib/features/booking/tata_ace/controllers/tata_ace_booking_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking_details/presentation/widget/car_booking_confirm_dialog.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class TataAceBookingController extends GetxController {
  // Text Controllers
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final promoTextController = TextEditingController();
  final instructionsController = TextEditingController();

  // Booking Model
  final booking = Rx<TataAceBookingModel>(
    TataAceBookingModel(
      vehicleName: '',
      vehicleImagePath: '',
      vehicleNumber: '',
      payloadCapacity: '',
      bodyType: '',
      pricePerKm: '',
      eta: '',
      driverName: 'Senthil',
      driverRating: 4.8,
      pickupAddress: '',
      dropAddress: '',
      distance: '',
      time: '30 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'km',
      baseFare: '₹500',
      distanceFare: '₹180',
      distanceFareLabel: 'Distance (10 km × ₹18)',
      loadingBase: '₹500',
      driverBata: '₹500',
      platformFee: '₹30',
      gst: '₹40',
      totalEstimate: '₹1250',
      loadingHelper: false,
      unloadingHelper: false,
      extraStops: false,
      returnTrip: false,
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
    final pricePerKmStr = args['pricePerKm'] ?? '₹18/km';
    final pricePerKm =
        double.tryParse(
          pricePerKmStr.replaceAll('₹', '').replaceAll('/km', ''),
        ) ??
        18;
    final distance = 10;
    final distanceFareValue = distance * pricePerKm;

    final basePrice = 500.0;
    final loadingBase =
        double.tryParse(
          args['loadingBase']?.toString().replaceAll('₹', '') ?? '500',
        ) ??
        500;
    final driverBata =
        double.tryParse(
          args['driverBata']
                  ?.toString()
                  .replaceAll('₹', '')
                  .replaceAll('/day', '') ??
              '500',
        ) ??
        500;

    booking.value = TataAceBookingModel(
      vehicleName: args['vehicleName'] ?? 'Tata Ace Gold',
      vehicleImagePath: args['imagePath'] ?? '',
      vehicleNumber: args['vehicleNumber'] ?? 'TN 22 AB 4589',
      payloadCapacity: args['payloadCapacity'] ?? '750 kg',
      bodyType: args['bodyType'] ?? 'OPEN BODY',
      pricePerKm: '₹${args['fare'] ?? '18'}/km',
      eta: 'ETA: 30 mins',
      driverName: 'Senthil',
      driverRating: 4.8,
      pickupAddress: '',
      dropAddress: '',
      distance: '10 km',
      time: '30 mins',
      scheduleDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      scheduleTime: DateFormat('hh:mm a').format(DateTime.now()),
      isBookNow: true,
      selectedRateType: 'km',
      baseFare: '₹${basePrice.toStringAsFixed(0)}',
      distanceFare: '₹${distanceFareValue.toStringAsFixed(0)}',
      distanceFareLabel: 'Distance (10 km × ₹${pricePerKm.toStringAsFixed(0)})',
      loadingBase: '₹${loadingBase.toStringAsFixed(0)}',
      driverBata: '₹${driverBata.toStringAsFixed(0)}',
      platformFee: '₹30',
      gst: '₹40',
      totalEstimate:
          '₹${(basePrice + distanceFareValue + loadingBase + driverBata + 30 + 40).toStringAsFixed(0)}',
      loadingHelper: false,
      unloadingHelper: false,
      extraStops: false,
      returnTrip: false,
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

  void toggleLoadingHelper(bool val) {
    booking.update((b) {
      b?.loadingHelper = val;
    });
    _updateFare();
  }

  void toggleUnloadingHelper(bool val) {
    booking.update((b) {
      b?.unloadingHelper = val;
    });
    _updateFare();
  }

  void toggleExtraStops(bool val) {
    booking.update((b) {
      b?.extraStops = val;
    });
    _updateFare();
  }

  void toggleReturnTrip(bool val) {
    booking.update((b) {
      b?.returnTrip = val;
    });
    _updateFare();
  }

  void _updateFare() {
    final b = booking.value;

    double baseFare = double.tryParse(b.baseFare.replaceAll('₹', '')) ?? 500;
    double distanceFare =
        double.tryParse(b.distanceFare.replaceAll('₹', '')) ?? 180;
    double loadingBase =
        double.tryParse(b.loadingBase.replaceAll('₹', '')) ?? 500;
    double driverBata =
        double.tryParse(b.driverBata.replaceAll('₹', '')) ?? 500;

    double additionalCharges = 0;
    if (b.loadingHelper) additionalCharges += 200;
    if (b.unloadingHelper) additionalCharges += 200;
    if (b.extraStops) additionalCharges += 100;
    // Return trip gives 50% off on base fare
    if (b.returnTrip) {
      baseFare = baseFare * 0.5;
    }

    double platformFee = 30;
    double gst = 40;

    double total =
        baseFare +
        distanceFare +
        loadingBase +
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
    if (code == 'ACE50') {
      booking.update((b) {
        b?.promoCode = code;
        b?.promoApplied = true;
        b?.promoMessage = '🎉 Get ₹50 off on Tata Ace booking!';
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
          '#ACE${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}',
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

class TataAceBookingModel {
  String vehicleName;
  String vehicleImagePath;
  String vehicleNumber;
  String payloadCapacity;
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
  String loadingBase;
  String driverBata;
  String platformFee;
  String gst;
  String totalEstimate;
  bool loadingHelper;
  bool unloadingHelper;
  bool extraStops;
  bool returnTrip;
  String promoCode;
  bool promoApplied;
  String promoMessage;
  String selectedPayment;

  TataAceBookingModel({
    required this.vehicleName,
    required this.vehicleImagePath,
    required this.vehicleNumber,
    required this.payloadCapacity,
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
    required this.loadingBase,
    required this.driverBata,
    required this.platformFee,
    required this.gst,
    required this.totalEstimate,
    required this.loadingHelper,
    required this.unloadingHelper,
    required this.extraStops,
    required this.returnTrip,
    required this.promoCode,
    required this.promoApplied,
    required this.promoMessage,
    required this.selectedPayment,
  });
}
