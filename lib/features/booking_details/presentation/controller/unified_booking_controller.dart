// lib/features/booking/unified/presentation/controller/unified_booking_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking_details/domain/usecases/create_booking_usecase.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_rate_type_toggle.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';
import 'package:userapp/utils/services/location_service.dart';

// Vehicle Type Enum
enum VehicleType {
  car,
  bus,
  miniBus,
  jcb,
  heavyLorry,
  tataAce,
  tractor,
  agriEquipment,
}

// Rate Type Option
// class RateTypeOption {
//   final String type;
//   final String labelKey;
//   final double fontSize;
//
//   RateTypeOption({
//     required this.type,
//     required this.labelKey,
//     this.fontSize = 13,
//   });
// }

// Service Option
class ServiceOption {
  final String key;
  final String labelKey;
  final double price;
  final RxBool value;
  final bool isPercentage;

  ServiceOption({
    required this.labelKey,
    required this.price,
    required this.value,
    this.isPercentage = false,
  }) : key = labelKey;
}

// Unified Booking Model
class UnifiedBookingModel {
  // Basic Info
  final int vehicleId;
  final String vehicleName;
  final String vehicleImagePath;
  final String vehicleNumber;
  final String driverName;
  final double driverRating;
  final VehicleType vehicleType;

  // Vehicle Specific Fields
  final String? seatingCapacity;
  final String? busCategory;
  final String? loadCapacity;
  final String? bodyType;
  final String? bucketType;
  final String? fuelType;
  final String? horsePower;
  final String? attachment;
  final String? equipmentType;
  final String? capacity;

  // Pricing
  final double basePrice;
  final double farePerKm;
  final double extraKmCharge;
  final double extraHourCharge;
  final double driverBata;
  final double operatorBata;
  final double loadingCharge;
  final double unloadingCharge;

  // Booking Details
  String pickupAddress;
  String dropAddress;
  double? pickupLat;
  double? pickupLng;
  double? dropLat;
  double? dropLng;
  double estimatedDistanceKm;
  double estimatedDurationHr;
  String selectedRateType;
  bool isBookNow;
  DateTime? scheduledAt;
  String paymentMethod;
  String promoCode;
  bool promoApplied;
  String promoMessage;
  double discountAmount;
  bool addLoadingHelper;
  bool addUnloadingHelper;
  bool insuranceCoverage;
  bool returnTripRequired;
  String specialInstructions;

  // Fare Breakdown
  double baseFare;
  double distanceFare;
  double additionalCharges;
  double platformFee;
  double gstAmount;
  double totalEstimate;

  UnifiedBookingModel({
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleImagePath,
    required this.vehicleNumber,
    required this.driverName,
    required this.driverRating,
    required this.vehicleType,
    this.seatingCapacity,
    this.busCategory,
    this.loadCapacity,
    this.bodyType,
    this.bucketType,
    this.fuelType,
    this.horsePower,
    this.attachment,
    this.equipmentType,
    this.capacity,
    required this.basePrice,
    required this.farePerKm,
    required this.extraKmCharge,
    required this.extraHourCharge,
    required this.driverBata,
    required this.operatorBata,
    required this.loadingCharge,
    required this.unloadingCharge,
    this.pickupAddress = '',
    this.dropAddress = '',
    this.pickupLat,
    this.pickupLng,
    this.dropLat,
    this.dropLng,
    this.estimatedDistanceKm = 10,
    this.estimatedDurationHr = 1,
    this.selectedRateType = 'km',
    this.isBookNow = true,
    this.scheduledAt,
    this.paymentMethod = 'UPI',
    this.promoCode = '',
    this.promoApplied = false,
    this.promoMessage = '',
    this.discountAmount = 0,
    this.addLoadingHelper = false,
    this.addUnloadingHelper = false,
    this.insuranceCoverage = false,
    this.returnTripRequired = false,
    this.specialInstructions = '',
    this.baseFare = 0,
    this.distanceFare = 0,
    this.additionalCharges = 0,
    this.platformFee = 50,
    this.gstAmount = 0,
    this.totalEstimate = 0,
  });

  UnifiedBookingModel copyWith({
    double? pickupLat, // ← add
    double? pickupLng, // ← add
    double? dropLat, // ← add
    double? dropLng, // ← add
    String? pickupAddress,
    String? dropAddress,
    double? estimatedDistanceKm,
    double? estimatedDurationHr,
    String? selectedRateType,
    bool? isBookNow,
    DateTime? scheduledAt,
    String? paymentMethod,
    String? promoCode,
    bool? promoApplied,
    String? promoMessage,
    double? discountAmount,
    bool? addLoadingHelper,
    bool? addUnloadingHelper,
    bool? insuranceCoverage,
    bool? returnTripRequired,
    String? specialInstructions,
    double? baseFare,
    double? distanceFare,
    double? platformFee, // ← add
    double? gstAmount, // ← add
    double? additionalCharges,
    double? totalEstimate,
  }) {
    return UnifiedBookingModel(
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      vehicleImagePath: vehicleImagePath,
      vehicleNumber: vehicleNumber,
      driverName: driverName,
      driverRating: driverRating,
      vehicleType: vehicleType,
      seatingCapacity: seatingCapacity,
      busCategory: busCategory,
      loadCapacity: loadCapacity,
      bodyType: bodyType,
      bucketType: bucketType,
      fuelType: fuelType,
      horsePower: horsePower,
      attachment: attachment,
      equipmentType: equipmentType,
      capacity: capacity,
      basePrice: basePrice,
      farePerKm: farePerKm,
      extraKmCharge: extraKmCharge,
      extraHourCharge: extraHourCharge,
      driverBata: driverBata,
      operatorBata: operatorBata,
      loadingCharge: loadingCharge,
      unloadingCharge: unloadingCharge,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropAddress: dropAddress ?? this.dropAddress,
      estimatedDistanceKm: estimatedDistanceKm ?? this.estimatedDistanceKm,
      estimatedDurationHr: estimatedDurationHr ?? this.estimatedDurationHr,
      selectedRateType: selectedRateType ?? this.selectedRateType,
      isBookNow: isBookNow ?? this.isBookNow,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      promoApplied: promoApplied ?? this.promoApplied,
      promoMessage: promoMessage ?? this.promoMessage,
      discountAmount: discountAmount ?? this.discountAmount,
      addLoadingHelper: addLoadingHelper ?? this.addLoadingHelper,
      addUnloadingHelper: addUnloadingHelper ?? this.addUnloadingHelper,
      insuranceCoverage: insuranceCoverage ?? this.insuranceCoverage,
      returnTripRequired: returnTripRequired ?? this.returnTripRequired,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      baseFare: baseFare ?? this.baseFare,
      distanceFare: distanceFare ?? this.distanceFare,
      additionalCharges: additionalCharges ?? this.additionalCharges,
      platformFee: platformFee ?? this.platformFee, // ← fix
      gstAmount: gstAmount ?? this.gstAmount, // ← fix
      totalEstimate: totalEstimate ?? this.totalEstimate,
      pickupLat: pickupLat ?? this.pickupLat, // ← add
      pickupLng: pickupLng ?? this.pickupLng, // ← add
      dropLat: dropLat ?? this.dropLat, // ← add
      dropLng: dropLng ?? this.dropLng, // ← add
    );
  }
}

class UnifiedBookingController extends GetxController {
  final CreateBookingUseCase _createBookingUseCase;

  UnifiedBookingController(this._createBookingUseCase);

  // Text Controllers
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final promoTextController = TextEditingController();
  final instructionsController = TextEditingController();

  // Booking Model
  final booking = Rxn<UnifiedBookingModel>();

  // UI States
  final isLoading = false.obs;
  final isBooking = false.obs;
  final errorMessage = ''.obs;

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

  // Service toggle states
  final acService = false.obs;
  final childSeat = false.obs;
  final musicSystem = false.obs;
  final extraLuggage = false.obs;
  final tourGuide = false.obs;
  final catering = false.obs;
  final photography = false.obs;
  final extraOperator = false.obs;
  final nightWork = false.obs;
  final rockBreaking = false.obs;
  final siteClearance = false.obs;
  final needLoadingHelper = false.obs;
  final needUnloadingHelper = false.obs;
  final insuranceCoverage = false.obs;
  final returnTripRequired = false.obs;
  final attachmentRental = false.obs;
  final fuelSupply = false.obs;
  final transport = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _initBookingFromArgs(args);
  }

  void _initBookingFromArgs(Map<String, dynamic> args) {
    AppLogger.info('=== Booking Controller Init ===');
    AppLogger.info('All args: $args');
    AppLogger.info('driverName from args: ${args['driverName']}');
    AppLogger.info('driver_name from args: ${args['driver_name']}');
    final vehicleTypeStr = args['vehicleType'] ?? args['categoryKey'] ?? 'car';
    final vehicleType = _getVehicleType(vehicleTypeStr);

    final vehicleId = args['id'] ?? args['vehicleId'] ?? 0;
    final vehicleName = args['vehicleName'] ?? args['name'] ?? 'Unknown';
    final vehicleImagePath = args['imagePath'] ?? '';
    final vehicleNumber = args['vehicleNumber'] ?? '';
    final driverName = args['driverName'] ?? 'Driver';
    final driverRating = (args['driverRating'] ?? 4.5).toDouble();
    final basePrice = (args['basePrice'] ?? 0.0).toDouble();

    /* // Parse farePerKm from various possible formats
    double farePerKm = 0.0;
    if (args['farePerKm'] != null) {
      farePerKm = args['farePerKm'].toDouble();
    } else if (args['fare'] != null) {
      final fareStr = args['fare'].toString();
      farePerKm =
          double.tryParse(fareStr.replaceAll('₹', '').replaceAll('/km', '')) ??
          0.0;
    }*/
    // இப்படி REPLACE பண்ணு:
    double farePerKm = 0.0;
    double farePerHour = 0.0;
    String detectedRateType = 'km'; // ← NEW

    if (args['fare'] != null) {
      final fareStr = args['fare'].toString();
      final cleaned = fareStr.replaceAll('₹', '').trim();
      if (cleaned.contains('/km')) {
        farePerKm = double.tryParse(cleaned.replaceAll('/km', '')) ?? 0.0;
        detectedRateType = 'km'; // ← NEW
      } else if (cleaned.contains('/hr')) {
        farePerHour = double.tryParse(cleaned.replaceAll('/hr', '')) ?? 0.0;
        detectedRateType = 'hour'; // ← NEW
      }
    }

    final extraKmCharge = (args['extraKmCharge'] ?? 0.0).toDouble();
    final extraHourCharge = (args['extraHourCharge'] ?? 0.0).toDouble();
    final driverBata = (args['driverBata'] ?? 0.0).toDouble();
    final operatorBata = (args['operatorBata'] ?? 0.0).toDouble();
    final loadingCharge = (args['loadingCharge'] ?? 0.0).toDouble();
    final unloadingCharge = (args['unloadingCharge'] ?? 0.0).toDouble();

    booking.value = UnifiedBookingModel(
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      vehicleImagePath: vehicleImagePath,
      vehicleNumber: vehicleNumber,
      driverName: driverName,
      driverRating: driverRating,
      vehicleType: vehicleType,
      seatingCapacity: args['seatingCapacity'],
      busCategory: args['busCategory'],
      loadCapacity: args['loadCapacity'],
      bodyType: args['bodyType'],
      bucketType: args['bucketType'],
      fuelType: args['fuelType'],
      horsePower: args['horsePower'],
      attachment: args['attachment'],
      equipmentType: args['equipmentType'],
      capacity: args['capacity'],
      basePrice: basePrice,
      farePerKm: farePerKm,
      extraKmCharge: extraKmCharge,
      // extraHourCharge: extraHourCharge,
      extraHourCharge: farePerHour > 0 ? farePerHour : extraHourCharge,

      driverBata: driverBata,
      operatorBata: operatorBata,
      loadingCharge: loadingCharge,
      unloadingCharge: unloadingCharge,
      estimatedDistanceKm: (args['distance']?.toDouble() ?? 10),
      // selectedRateType: args['selectedRateType'] ?? 'km',
      selectedRateType: args['selectedRateType'] ?? detectedRateType,
    );

    _updateFare();
  }

  VehicleType _getVehicleType(String key) {
    switch (key.toLowerCase()) {
      case 'car':
        return VehicleType.car;
      case 'bus':
        return VehicleType.bus;
      case 'minibus':
        return VehicleType.miniBus;
      case 'jcb':
        return VehicleType.jcb;
      case 'lorry':
      case 'heavylorry':
        return VehicleType.heavyLorry;
      case 'tataace':
        return VehicleType.tataAce;
      case 'tractor':
        return VehicleType.tractor;
      case 'agri':
      case 'agriequipment':
        return VehicleType.agriEquipment;
      default:
        return VehicleType.car;
    }
  }

  // Rate Type Options
  /* List<RateTypeOption> get rateTypeOptions {
    final type = booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
      case VehicleType.bus:
      case VehicleType.miniBus:
      case VehicleType.heavyLorry:
      case VehicleType.tataAce:
        return [
          RateTypeOption(type: 'km', labelKey: 'per_km'),
          RateTypeOption(type: 'hour', labelKey: 'per_hour'),
          RateTypeOption(type: 'day', labelKey: 'per_day'),
        ];
      case VehicleType.jcb:
      case VehicleType.tractor:
      case VehicleType.agriEquipment:
        return [
          RateTypeOption(type: 'hour', labelKey: 'per_hour'),
          RateTypeOption(type: 'day', labelKey: 'per_day'),
          RateTypeOption(type: 'load', labelKey: 'per_load'),
        ];
    }
  }*/
  List<RateTypeOption> get rateTypeOptions => [];
  // Service Options
  List<ServiceOption> get serviceOptions {
    final type = booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
        return [
          ServiceOption(labelKey: 'ac_service', price: 200, value: acService),
          ServiceOption(labelKey: 'child_seat', price: 150, value: childSeat),
          ServiceOption(
            labelKey: 'music_system',
            price: 100,
            value: musicSystem,
          ),
          ServiceOption(
            labelKey: 'extra_luggage',
            price: 200,
            value: extraLuggage,
          ),
        ];
      case VehicleType.bus:
      case VehicleType.miniBus:
        return [
          ServiceOption(labelKey: 'tour_guide', price: 500, value: tourGuide),
          ServiceOption(labelKey: 'catering', price: 300, value: catering),
          ServiceOption(
            labelKey: 'extra_luggage',
            price: 200,
            value: extraLuggage,
          ),
          ServiceOption(
            labelKey: 'photography',
            price: 400,
            value: photography,
          ),
        ];
      case VehicleType.jcb:
        return [
          ServiceOption(
            labelKey: 'extra_operator',
            price: 500,
            value: extraOperator,
          ),
          ServiceOption(labelKey: 'night_work', price: 300, value: nightWork),
          ServiceOption(
            labelKey: 'rock_breaking',
            price: 400,
            value: rockBreaking,
          ),
          ServiceOption(
            labelKey: 'site_clearance',
            price: 250,
            value: siteClearance,
          ),
        ];
      case VehicleType.heavyLorry:
      case VehicleType.tataAce:
        return [
          ServiceOption(
            labelKey: 'need_loading_helper',
            price: 300,
            value: needLoadingHelper,
          ),
          ServiceOption(
            labelKey: 'need_unloading_helper',
            price: 300,
            value: needUnloadingHelper,
          ),
          ServiceOption(
            labelKey: 'insurance_coverage',
            price: 150,
            value: insuranceCoverage,
          ),
          ServiceOption(
            labelKey: 'return_trip_required',
            price: 0,
            value: returnTripRequired,
            isPercentage: true,
          ),
        ];
      case VehicleType.tractor:
        return [
          ServiceOption(
            labelKey: 'attachment_rental',
            price: 200,
            value: attachmentRental,
          ),
          ServiceOption(labelKey: 'fuel_supply', price: 300, value: fuelSupply),
          ServiceOption(labelKey: 'night_work', price: 400, value: nightWork),
          ServiceOption(labelKey: 'transport', price: 500, value: transport),
        ];
      case VehicleType.agriEquipment:
        return [
          ServiceOption(
            labelKey: 'extra_operator',
            price: 400,
            value: extraOperator,
          ),
          ServiceOption(labelKey: 'fuel_supply', price: 500, value: fuelSupply),
          ServiceOption(labelKey: 'night_work', price: 600, value: nightWork),
          ServiceOption(labelKey: 'transport', price: 700, value: transport),
        ];
    }
  }

  // Helper Getters
  String getVehicleDisplayName() {
    final type = booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
        return booking.value?.seatingCapacity ?? 'Car';
      case VehicleType.bus:
      case VehicleType.miniBus:
        return booking.value?.busCategory ?? 'Bus';
      case VehicleType.jcb:
        return booking.value?.bucketType ?? 'JCB';
      case VehicleType.heavyLorry:
      case VehicleType.tataAce:
        return booking.value?.loadCapacity ?? 'Lorry';
      case VehicleType.tractor:
        return booking.value?.horsePower ?? 'Tractor';
      case VehicleType.agriEquipment:
        return booking.value?.capacity ?? 'Agri';
    }
  }

  IconData getVehicleIcon() {
    final type = booking.value?.vehicleType ?? VehicleType.car;
    switch (type) {
      case VehicleType.car:
        return Icons.directions_car_rounded;
      case VehicleType.bus:
      case VehicleType.miniBus:
        return Icons.directions_bus_rounded;
      case VehicleType.jcb:
        return Icons.construction_rounded;
      case VehicleType.heavyLorry:
      case VehicleType.tataAce:
        return Icons.local_shipping_rounded;
      case VehicleType.tractor:
        return Icons.agriculture_rounded;
      case VehicleType.agriEquipment:
        return Icons.grass_rounded;
    }
  }

  // Schedule Methods
  void toggleBookNow(bool val) {
    booking.update((b) {
      b?.isBookNow = val;
      if (val) b?.scheduledAt = null;
    });
  }

  void onDateSelected(DateTime date) {
    booking.update((b) {
      b?.scheduledAt = date;
    });
  }

  void onTimeSelected(TimeOfDay time) {
    booking.update((b) {
      final date = b?.scheduledAt ?? DateTime.now();
      final newDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      b?.scheduledAt = newDateTime;
    });
  }

  // Rate Type
  void selectRateType(String type) {
    // booking.update((b) {
    //   b?.selectedRateType = type;
    // });
    // _updateFare();
    AppLogger.info("RateType change disabled");
  }

  // Service Toggles
  void toggleService(String key, bool val) {
    switch (key) {
      case 'ac_service':
        acService.value = val;
        break;
      case 'child_seat':
        childSeat.value = val;
        break;
      case 'music_system':
        musicSystem.value = val;
        break;
      case 'extra_luggage':
        extraLuggage.value = val;
        break;
      case 'tour_guide':
        tourGuide.value = val;
        break;
      case 'catering':
        catering.value = val;
        break;
      case 'photography':
        photography.value = val;
        break;
      case 'extra_operator':
        extraOperator.value = val;
        break;
      case 'night_work':
        nightWork.value = val;
        break;
      case 'rock_breaking':
        rockBreaking.value = val;
        break;
      case 'site_clearance':
        siteClearance.value = val;
        break;
      case 'need_loading_helper':
        needLoadingHelper.value = val;
        break;
      case 'need_unloading_helper':
        needUnloadingHelper.value = val;
        break;
      case 'insurance_coverage':
        insuranceCoverage.value = val;
        break;
      case 'return_trip_required':
        returnTripRequired.value = val;
        break;
      case 'attachment_rental':
        attachmentRental.value = val;
        break;
      case 'fuel_supply':
        fuelSupply.value = val;
        break;
      case 'transport':
        transport.value = val;
        break;
    }
    _updateFare();
  }

  bool getServiceValue(String key) {
    switch (key) {
      case 'ac_service':
        return acService.value;
      case 'child_seat':
        return childSeat.value;
      case 'music_system':
        return musicSystem.value;
      case 'extra_luggage':
        return extraLuggage.value;
      case 'tour_guide':
        return tourGuide.value;
      case 'catering':
        return catering.value;
      case 'photography':
        return photography.value;
      case 'extra_operator':
        return extraOperator.value;
      case 'night_work':
        return nightWork.value;
      case 'rock_breaking':
        return rockBreaking.value;
      case 'site_clearance':
        return siteClearance.value;
      case 'need_loading_helper':
        return needLoadingHelper.value;
      case 'need_unloading_helper':
        return needUnloadingHelper.value;
      case 'insurance_coverage':
        return insuranceCoverage.value;
      case 'return_trip_required':
        return returnTripRequired.value;
      case 'attachment_rental':
        return attachmentRental.value;
      case 'fuel_supply':
        return fuelSupply.value;
      case 'transport':
        return transport.value;
      default:
        return false;
    }
  }

  double _getAdditionalCharges() {
    double charges = 0;
    for (var service in serviceOptions) {
      if (getServiceValue(service.key)) {
        charges += service.price;
      }
    }
    // Return trip discount (50% off base fare)
    if (returnTripRequired.value && booking.value != null) {
      charges -= booking.value!.baseFare * 0.5;
    }
    return charges;
  }

  void _updateFare() {
    final b = booking.value;
    if (b == null) return;

    double baseFare = b.basePrice;
    double distanceFare = 0;

    if (b.selectedRateType == 'km' && b.estimatedDistanceKm > 0) {
      distanceFare = b.farePerKm * b.estimatedDistanceKm;
    } else if (b.selectedRateType == 'hour' && b.estimatedDurationHr > 0) {
      distanceFare = b.extraHourCharge * b.estimatedDurationHr;
    }

    double operatorCharge =
        (b.vehicleType == VehicleType.car ||
            b.vehicleType == VehicleType.bus ||
            b.vehicleType == VehicleType.miniBus ||
            b.vehicleType == VehicleType.heavyLorry ||
            b.vehicleType == VehicleType.tataAce)
        ? b.driverBata
        : b.operatorBata;

    double additionalCharges = _getAdditionalCharges();

    if (b.addLoadingHelper) additionalCharges += b.loadingCharge;
    if (b.addUnloadingHelper) additionalCharges += b.unloadingCharge;
    if (b.insuranceCoverage) additionalCharges += 150;

    double subtotal =
        baseFare + distanceFare + operatorCharge + additionalCharges;
    double platformFee = 50;
    double gstAmount = (subtotal * 0.05).roundToDouble();
    double discountAmount = b.discountAmount;
    double totalEstimate = subtotal + platformFee + gstAmount - discountAmount;

    booking.update((b) {
      b?.baseFare = baseFare;
      b?.distanceFare = distanceFare;
      b?.additionalCharges = additionalCharges;
      b?.gstAmount = gstAmount;
      b?.totalEstimate = totalEstimate;
    });
  }

  // Promo Code
  void applyPromoCode() {
    final code = promoTextController.text.trim().toUpperCase();
    if (code.isEmpty) {
      AppSnackbar.error('enter_promo'.tr);
      return;
    }

    if (code == 'FIRST50') {
      booking.update((b) {
        b?.promoCode = code;
        b?.promoApplied = true;
        b?.promoMessage = '🎉 Get ₹50 off!';
        b?.discountAmount = 50;
      });
      _updateFare();
    } else {
      booking.update((b) {
        b?.promoApplied = false;
        b?.promoMessage = '';
        b?.discountAmount = 0;
      });
      AppSnackbar.error('promo_invalid_msg'.tr);
    }
  }

  // Payment
  void selectPayment(String method) {
    booking.update((b) {
      b?.paymentMethod = method;
    });
  }

  // Actions
  void onCallDriver() {
    AppSnackbar.success('Calling ${booking.value?.driverName}...');
  }

  // In unified_booking_controller.dart, update the onConfirmBooking method:

  Future<void> onConfirmBooking() async {
    final b = booking.value;
    if (b == null) return;

    if (pickupController.text.isEmpty) {
      AppSnackbar.error('enter_pickup_location'.tr);
      return;
    }
    if (dropController.text.isEmpty) {
      AppSnackbar.error('enter_drop_location'.tr);
      return;
    }

    isBooking.value = true;

    final requestBody = {
      'vehicleId': b.vehicleId,
      'pickupAddress': pickupController.text,
      'dropAddress': dropController.text,
      'pickupLat': b.pickupLat,
      'pickupLng': b.pickupLng,
      'dropLat': b.dropLat,
      'dropLng': b.dropLng,
      'isBookNow': b.isBookNow,
      'scheduledAt': b.scheduledAt?.toIso8601String(),
      'rateType': b.selectedRateType,
      'estimatedDistanceKm': b.estimatedDistanceKm,
      'estimatedDurationHr': b.estimatedDurationHr,
      'paymentMethod': b.paymentMethod,
      'promoCode': b.promoApplied ? b.promoCode : '',
      'addLoadingHelper': needLoadingHelper.value,
      'addUnloadingHelper': needUnloadingHelper.value,
      'insuranceCoverage': insuranceCoverage.value,
      'returnTripRequired': returnTripRequired.value,
      'specialInstructions': instructionsController.text,
    };

    AppLogger.info('Creating booking: $requestBody');

    final result = await _createBookingUseCase(requestBody);

    isBooking.value = false;

    // ✅ Fix: Check if result is success and data is not null
    if (result.isSuccess && result.data != null) {
      final data = result.data!;

      // ✅ Check if bookingRef exists before showing dialog
      if (data['bookingRef'] != null) {
        AppLogger.info('Booking created: ${data['bookingRef']}');
        _showBookingSuccessDialog(
          bookingRef: data['bookingRef'],
          driverName: data['driver']?['name'] ?? 'Driver',
          driverMobile: data['driver']?['mobile'] ?? '',
          totalEstimate: b.totalEstimate,
        );
      } else {
        // Booking created but no bookingRef (should not happen, but handle gracefully)
        AppSnackbar.success('booking_created'.tr);
        Get.back(); // Go back to previous screen
      }
    } else {
      // Show error message from API
      final errorMsg = result.error ?? 'booking_failed'.tr;
      AppSnackbar.error(errorMsg);
    }
  }

  void _showBookingSuccessDialog({
    required String bookingRef,
    required String driverName,
    required String driverMobile,
    required double totalEstimate,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50.sp),
            SizedBox(height: 12.h),
            Text(
              'booking_confirmed'.tr,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoRow('booking_id'.tr, bookingRef),
            SizedBox(height: 8.h),
            _infoRow('driver_name'.tr, driverName),
            SizedBox(height: 8.h),
            _infoRow('driver_mobile'.tr, driverMobile),
            SizedBox(height: 8.h),
            _infoRow('total_amount'.tr, '₹${totalEstimate.toStringAsFixed(0)}'),
            SizedBox(height: 12.h),
            Text(
              'waiting_driver_acceptance'.tr,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              // Navigate to bookings tab
              Get.until((route) => route.settings.name == Routes.wrapper);
              Get.find<HomeController>().currentNavIndex.value = 1;
            },
            child: Text('view_bookings'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to previous screen
            },
            child: Text('ok'.tr),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  ///========================Location details==================================

  // Controller-ல் copyWith use பண்றதுக்கு பதிலா
  // இந்த fields தனியா obs-ஆ வச்சிருக்கோம் — அது போதும்

  final pickupLat = 0.0.obs;
  final pickupLng = 0.0.obs;
  final dropLat = 0.0.obs;
  final dropLng = 0.0.obs;
  final isLoadingLocation = false.obs;
  final LocationService _locationService = LocationService();
  // fetchCurrentLocation fix
  Future<void> fetchCurrentLocation() async {
    isLoadingLocation.value = true;

    final locationResult = await _locationService.getCurrentLocation();

    if (locationResult != null) {
      pickupLat.value = locationResult.lat;
      pickupLng.value = locationResult.lng;
      pickupController.text = locationResult.address;

      final current = booking.value;
      if (current != null) {
        booking.value = current.copyWith(
          pickupAddress: locationResult.address,
          pickupLat: locationResult.lat,
          pickupLng: locationResult.lng,
        );
      }
    } else {
      Get.snackbar(
        'error'.tr,
        'enable_location'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isLoadingLocation.value = false;
  }
  /*
  Future<void> fetchCurrentLocation() async {
    isLoadingLocation.value = true;

    final position = await LocationService.g();

    if (position != null) {
      pickupLat.value = position.latitude;
      pickupLng.value = position.longitude;

      final address = await LocationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      pickupController.text = address;

      // ✅
      final current = booking.value;
      if (current != null) {
        booking.value = current.copyWith(
          pickupAddress: address,
          pickupLat: position.latitude,
          pickupLng: position.longitude,
        );
      }
    } else {
      Get.snackbar(
        'error'.tr,
        'enable_location'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isLoadingLocation.value = false;
  }
*/

  // setDropLocation fix
  Future<void> setDropLocation(String address, double lat, double lng) async {
    dropLat.value = lat;
    dropLng.value = lng;
    dropController.text = address;

    final current = booking.value;
    if (current != null) {
      double distanceKm = 0.0;

      if (pickupLat.value != 0.0 && pickupLng.value != 0.0) {
        distanceKm =
            Geolocator.distanceBetween(
              pickupLat.value,
              pickupLng.value,
              lat,
              lng,
            ) /
            1000;
      }

      // ✅ dropLat/Lng + distance — எல்லாம் ஒரே copyWith-ல் update பண்ணு
      booking.value = current.copyWith(
        dropAddress: address,
        dropLat: lat, // ← இது add பண்ணு
        dropLng: lng, // ← இது add பண்ணு
        estimatedDistanceKm: distanceKm,
      );

      recalculateFare();
    }
  }

  void recalculateFare() {
    final current = booking.value;
    if (current == null) return;

    final distanceKm = current.estimatedDistanceKm;

    double baseFare = current.basePrice;
    double distanceFare = 0.0;

    switch (current.selectedRateType) {
      case 'km':
        distanceFare = distanceKm * current.farePerKm;
        break;
      case 'hour':
        distanceFare = current.estimatedDurationHr * current.extraHourCharge;
        break;
      default:
        distanceFare = 0.0;
    }

    final operatorCharge = current.driverBata + current.operatorBata;
    final subtotal =
        baseFare + distanceFare + operatorCharge + current.additionalCharges;
    final platformFee = current.platformFee;
    final gst = subtotal * 0.18;
    final total = subtotal + platformFee + gst - current.discountAmount;

    booking.value = current.copyWith(
      baseFare: baseFare,
      distanceFare: distanceFare,
      gstAmount: gst,
      totalEstimate: total,
    );
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;
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
