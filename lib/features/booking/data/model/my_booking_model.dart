// lib/features/booking/data/model/my_booking_model.dart
// ════════════════════════════════════════════════════════════════
//  MY BOOKING MODEL — Data Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/features/booking/domain/entities/my_booking_entity.dart';

class MyBookingModel {
  final int id;
  final String bookingRef;
  final String status;
  final String vehicleName;
  final String categorySlug;
  final String? imagePath;
  final String pickupAddress;
  final String dropAddress;
  final String totalEstimate;
  final String? finalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String driverName;
  final String driverRating;
  final bool isBookNow;
  final DateTime? scheduledAt;
  final DateTime createdAt;
  final DateTime? completedAt;

  const MyBookingModel({
    required this.id,
    required this.bookingRef,
    required this.status,
    required this.vehicleName,
    required this.categorySlug,
    this.imagePath,
    required this.pickupAddress,
    required this.dropAddress,
    required this.totalEstimate,
    this.finalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.driverName,
    required this.driverRating,
    required this.isBookNow,
    this.scheduledAt,
    required this.createdAt,
    this.completedAt,
  });

  // ── Computed helpers ─────────────────────────────────────────
  bool get isActive => status == 'accepted' || status == 'ongoing';

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

  // ── From JSON ────────────────────────────────────────────────
  factory MyBookingModel.fromJson(Map<String, dynamic> json) {
    return MyBookingModel(
      id: _parseInt(json['id']),
      bookingRef: _parseString(json['bookingRef']),
      status: _parseString(json['status']),
      vehicleName: _parseString(json['vehicleName']),
      categorySlug: _parseString(json['categorySlug']),
      imagePath: _parseNullableString(json['imagePath']),
      pickupAddress: _parseString(json['pickupAddress']),
      dropAddress: _parseString(json['dropAddress']),
      totalEstimate: _parseString(json['totalEstimate']),
      finalAmount: _parseNullableString(json['finalAmount']),
      paymentMethod: _parseString(json['paymentMethod']),
      paymentStatus: _parseString(json['paymentStatus']),
      driverName: _parseString(json['driverName']),
      driverRating: _parseString(json['driverRating']),
      isBookNow: _parseBool(json['isBookNow']),
      scheduledAt: _parseNullableDateTime(json['scheduledAt']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: _parseNullableDateTime(json['completedAt']),
    );
  }

  // ── Safe parsers ─────────────────────────────────────────────
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
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }

  MyBookingEntity toEntity() => MyBookingEntity(
    id: id,
    bookingRef: bookingRef,
    status: status,
    vehicleName: vehicleName,
    categorySlug: categorySlug,
    imagePath: imagePath,
    pickupAddress: pickupAddress,
    dropAddress: dropAddress,
    totalEstimate: totalEstimate,
    finalAmount: finalAmount,
    paymentMethod: paymentMethod,
    paymentStatus: paymentStatus,
    driverName: driverName,
    driverRating: driverRating,
    isBookNow: isBookNow,
    scheduledAt: scheduledAt,
    createdAt: createdAt,
    completedAt: completedAt,
  );
}

// lib/features/booking/data/model/my_bookings_response_model.dart
// ════════════════════════════════════════════════════════════════
//  MY BOOKINGS RESPONSE MODEL — Data Layer
// ════════════════════════════════════════════════════════════════

class MyBookingsResponseModel {
  final List<MyBookingModel> bookings;
  final int total;
  final int limit;
  final int offset;

  const MyBookingsResponseModel({
    required this.bookings,
    required this.total,
    required this.limit,
    required this.offset,
  });

  factory MyBookingsResponseModel.fromJson(Map<String, dynamic> json) {
    // json here is already the 'data' object from API response
    return MyBookingsResponseModel(
      bookings: _parseBookingsList(json['bookings']),
      total: _parseInt(json['total']),
      limit: _parseInt(json['limit']),
      offset: _parseInt(json['offset']),
    );
  }

  static List<MyBookingModel> _parseBookingsList(dynamic raw) {
    final list = raw as List? ?? [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(MyBookingModel.fromJson)
        .toList();
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? 0;
    return 0;
  }

  MyBookingsResponseEntity toEntity() => MyBookingsResponseEntity(
    bookings: bookings.map((b) => b.toEntity()).toList(),
    total: total,
    limit: limit,
    offset: offset,
  );
}
