// lib/features/booking/data/model/my_booking_detail_model.dart
// ════════════════════════════════════════════════════════════════
//  MY BOOKING DETAIL MODEL — Data Layer (FIXED)
// ════════════════════════════════════════════════════════════════

import 'package:userapp/features/booking/domain/entities/my_booking_detail_entity.dart';

class MyBookingDetailModel {
  final int id;
  final String bookingRef;
  final String status;

  // Vehicle
  final int vehicleId;
  final String vehicleName;
  final String vehicleCategoryName;
  final String vehicleCategorySlug;
  final String? vehicleImagePath;
  final String basePrice;
  final String pricingModel;

  // Driver
  final int driverId;
  final String driverName;
  final String? driverPhoto;
  final String driverRating;
  final String driverMobile;

  // Trip
  final String pickupAddress;
  final String dropAddress;
  final bool isBookNow;
  final DateTime? scheduledAt;
  final String rateType;
  final String estimatedDistanceKm;
  final String estimatedDurationHr;

  // Fare
  final String baseFare;
  final String distanceFare;
  final String platformFee;
  final String gstAmount;
  final String discountAmount;
  final String? promoCode;
  final String promoDiscount;
  final String totalEstimate;
  final String? finalAmount;

  // Services
  final bool addLoadingHelper;
  final bool addUnloadingHelper;
  final bool insuranceCoverage;
  final bool returnTripRequired;

  // Payment
  final String paymentMethod;
  final String paymentStatus;

  // Misc
  final String? specialInstructions;
  final String? driverRejectionReason;

  // Timestamps
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancelledBy;

  // Status history
  final List<BookingStatusHistoryModel> statusHistory;

  const MyBookingDetailModel({
    required this.id,
    required this.bookingRef,
    required this.status,
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleCategoryName,
    required this.vehicleCategorySlug,
    this.vehicleImagePath,
    required this.basePrice,
    required this.pricingModel,
    required this.driverId,
    required this.driverName,
    this.driverPhoto,
    required this.driverRating,
    required this.driverMobile,
    required this.pickupAddress,
    required this.dropAddress,
    required this.isBookNow,
    this.scheduledAt,
    required this.rateType,
    required this.estimatedDistanceKm,
    required this.estimatedDurationHr,
    required this.baseFare,
    required this.distanceFare,
    required this.platformFee,
    required this.gstAmount,
    required this.discountAmount,
    this.promoCode,
    required this.promoDiscount,
    required this.totalEstimate,
    this.finalAmount,
    required this.addLoadingHelper,
    required this.addUnloadingHelper,
    required this.insuranceCoverage,
    required this.returnTripRequired,
    required this.paymentMethod,
    required this.paymentStatus,
    this.specialInstructions,
    this.driverRejectionReason,
    required this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancelledBy,
    required this.statusHistory,
  });

  // ── Computed helpers ─────────────────────────────────────────
  String get displayAmount {
    final raw = finalAmount ?? totalEstimate;
    final value = double.tryParse(raw) ?? 0;
    return '₹${value.toStringAsFixed(0)}';
  }

  String get displayDate {
    final d = createdAt.toLocal();
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  String get displayTime {
    final d = createdAt.toLocal();
    final h = d.hour > 12
        ? d.hour - 12
        : d.hour == 0
        ? 12
        : d.hour;
    final m = d.minute.toString().padLeft(2, '0');
    final suffix = d.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $suffix';
  }

  String get displayPaymentMethod {
    switch (paymentMethod.toLowerCase()) {
      case 'cash':
        return 'Cash Payment';
      case 'upi':
        return 'UPI Payment';
      case 'card':
        return 'Card Payment';
      default:
        return paymentMethod;
    }
  }

  String? get paymentNote {
    switch (paymentStatus) {
      case 'pending':
        return 'pay_on_arrival';
      case 'paid':
        return 'payment_done';
      default:
        return null;
    }
  }

  String get displayEta {
    final hr = double.tryParse(estimatedDurationHr) ?? 0;
    if (hr == 0) return '< 1 hr';
    if (hr < 1) return '${(hr * 60).toInt()} min';
    return '${hr.toStringAsFixed(0)} hr';
  }

  // ── From JSON (FIXED with null safety) ─────────────────────────────────
  factory MyBookingDetailModel.fromJson(Map<String, dynamic> json) {
    // Safe extraction with null checks - this prevents the null cast error
    final vehicle = (json['vehicle'] as Map<String, dynamic>?) ?? {};
    final driver = (json['driver'] as Map<String, dynamic>?) ?? {};
    final trip = (json['trip'] as Map<String, dynamic>?) ?? {};
    final fare = (json['fare'] as Map<String, dynamic>?) ?? {};
    final services = (json['services'] as Map<String, dynamic>?) ?? {};
    final payment = (json['payment'] as Map<String, dynamic>?) ?? {};
    final ts = (json['timestamps'] as Map<String, dynamic>?) ?? {};

    // Safe history parsing
    final history = (json['statusHistory'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((e) => BookingStatusHistoryModel.fromJson(e))
        .toList();

    return MyBookingDetailModel(
      id: json['id'] as int? ?? 0,
      bookingRef: _parseString(json['bookingRef']),
      status: _parseString(json['status']),

      vehicleId: _parseInt(vehicle['id']),
      vehicleName: _parseString(vehicle['name']),
      vehicleCategoryName: _parseString(vehicle['categoryName']),
      vehicleCategorySlug: _parseString(vehicle['categorySlug']),
      vehicleImagePath: _parseNullableString(vehicle['imagePath']),
      basePrice: _parseString(vehicle['basePrice']),
      pricingModel: _parseString(vehicle['pricingModel']),

      driverId: _parseInt(driver['id']),
      driverName: _parseString(driver['name']),
      driverPhoto: _parseNullableString(driver['photo']),
      driverRating: _parseString(driver['rating']),
      driverMobile: _parseString(driver['mobile']),

      pickupAddress: _parseString(trip['pickupAddress']),
      dropAddress: _parseString(trip['dropAddress']),
      isBookNow: _parseBool(trip['isBookNow']),
      scheduledAt: _parseNullableDateTime(trip['scheduledAt']),
      rateType: _parseString(trip['rateType']),
      estimatedDistanceKm: _parseString(trip['estimatedDistanceKm']),
      estimatedDurationHr: _parseString(trip['estimatedDurationHr']),

      baseFare: _parseString(fare['baseFare']),
      distanceFare: _parseString(fare['distanceFare']),
      platformFee: _parseString(fare['platformFee']),
      gstAmount: _parseString(fare['gstAmount']),
      discountAmount: _parseString(fare['discountAmount']),
      promoCode: _parseNullableString(fare['promoCode']),
      promoDiscount: _parseString(fare['promoDiscount']),
      totalEstimate: _parseString(fare['totalEstimate']),
      finalAmount: _parseNullableString(fare['finalAmount']),

      addLoadingHelper: _parseBool(services['addLoadingHelper']),
      addUnloadingHelper: _parseBool(services['addUnloadingHelper']),
      insuranceCoverage: _parseBool(services['insuranceCoverage']),
      returnTripRequired: _parseBool(services['returnTripRequired']),

      paymentMethod: _parseString(payment['method']),
      paymentStatus: _parseString(payment['status']),

      specialInstructions: _parseNullableString(json['specialInstructions']),
      driverRejectionReason: _parseNullableString(
        json['driverRejectionReason'],
      ),

      createdAt: _parseRequiredDateTime(ts['createdAt']),
      acceptedAt: _parseNullableDateTime(ts['acceptedAt']),
      startedAt: _parseNullableDateTime(ts['startedAt']),
      completedAt: _parseNullableDateTime(ts['completedAt']),
      cancelledAt: _parseNullableDateTime(ts['cancelledAt']),
      cancelledBy: _parseNullableString(ts['cancelledBy']),

      statusHistory: history,
    );
  }

  // ── Safe parsers (UPDATED) ─────────────────────────────────────────────
  static String _parseString(dynamic v) {
    if (v == null) return '';
    return v.toString();
  }

  static String? _parseNullableString(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? 0;
    return 0;
  }

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is String) return v.toLowerCase() == 'true';
    return false;
  }

  static DateTime? _parseNullableDateTime(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) {
      try {
        return DateTime.parse(v);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static DateTime _parseRequiredDateTime(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) {
      try {
        return DateTime.parse(v);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  // ── To Entity ────────────────────────────────────────────────
  MyBookingDetailEntity toEntity() => MyBookingDetailEntity(
    id: id,
    bookingRef: bookingRef,
    status: status,
    vehicleId: vehicleId,
    vehicleName: vehicleName,
    vehicleCategoryName: vehicleCategoryName,
    vehicleCategorySlug: vehicleCategorySlug,
    vehicleImagePath: vehicleImagePath,
    basePrice: basePrice,
    pricingModel: pricingModel,
    driverId: driverId,
    driverName: driverName,
    driverPhoto: driverPhoto,
    driverRating: driverRating,
    driverMobile: driverMobile,
    pickupAddress: pickupAddress,
    dropAddress: dropAddress,
    isBookNow: isBookNow,
    scheduledAt: scheduledAt,
    rateType: rateType,
    estimatedDistanceKm: estimatedDistanceKm,
    estimatedDurationHr: estimatedDurationHr,
    baseFare: baseFare,
    distanceFare: distanceFare,
    platformFee: platformFee,
    gstAmount: gstAmount,
    discountAmount: discountAmount,
    promoCode: promoCode,
    promoDiscount: promoDiscount,
    totalEstimate: totalEstimate,
    finalAmount: finalAmount,
    addLoadingHelper: addLoadingHelper,
    addUnloadingHelper: addUnloadingHelper,
    insuranceCoverage: insuranceCoverage,
    returnTripRequired: returnTripRequired,
    paymentMethod: paymentMethod,
    paymentStatus: paymentStatus,
    specialInstructions: specialInstructions,
    driverRejectionReason: driverRejectionReason,
    createdAt: createdAt,
    acceptedAt: acceptedAt,
    startedAt: startedAt,
    completedAt: completedAt,
    cancelledAt: cancelledAt,
    cancelledBy: cancelledBy,
    statusHistory: statusHistory
        .map(
          (h) => BookingStatusHistoryEntity(
            from: h.from,
            to: h.to,
            by: h.by,
            note: h.note,
            timestamp: h.timestamp,
          ),
        )
        .toList(),
  );
}

// ── Status History Model (FIXED) ──────────────────────────────────────────────

class BookingStatusHistoryModel {
  final String? from;
  final String to;
  final String by;
  final String note;
  final DateTime timestamp;

  const BookingStatusHistoryModel({
    this.from,
    required this.to,
    required this.by,
    required this.note,
    required this.timestamp,
  });

  factory BookingStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return BookingStatusHistoryModel(
      from: json['from'] as String?,
      to: json['to'] as String? ?? '',
      by: json['by'] as String? ?? '',
      note: json['note'] as String? ?? '',
      timestamp: _parseTimestamp(json['timestamp']),
    );
  }

  static DateTime _parseTimestamp(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) {
      try {
        return DateTime.parse(v);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}
