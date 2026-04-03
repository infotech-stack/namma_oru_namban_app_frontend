// lib/features/booking/unified/data/models/booking_model.dart

import 'package:userapp/features/booking_details/domain/entities/booking_entity.dart';

class BookingModel {
  final int id;
  final String bookingRef;
  final String status;
  final int vehicleId;
  final String vehicleName;
  final String? vehicleImagePath;
  final String? vehicleNumber;
  final String? driverName;
  final double? driverRating;
  final String pickupAddress;
  final String dropAddress;
  final bool isBookNow;
  final DateTime? scheduledAt;
  final String rateType;
  final double estimatedDistanceKm;
  final double estimatedDurationHr;
  final double baseFare;
  final double distanceFare;
  final double platformFee;
  final double gstAmount;
  final double discountAmount;
  final double totalEstimate;
  final double? finalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final bool addLoadingHelper;
  final bool addUnloadingHelper;
  final bool insuranceCoverage;
  final bool returnTripRequired;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  BookingModel({
    required this.id,
    required this.bookingRef,
    required this.status,
    required this.vehicleId,
    required this.vehicleName,
    this.vehicleImagePath,
    this.vehicleNumber,
    this.driverName,
    this.driverRating,
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
    required this.totalEstimate,
    this.finalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.addLoadingHelper,
    required this.addUnloadingHelper,
    required this.insuranceCoverage,
    required this.returnTripRequired,
    this.specialInstructions,
    required this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: _parseInt(json['id']),
      bookingRef: _parseString(json['bookingRef']),
      status: _parseString(json['status']),
      vehicleId: _parseInt(json['vehicleId']),
      vehicleName: _parseString(json['vehicleName']),
      vehicleImagePath: _parseNullableString(json['imagePath']),
      vehicleNumber: _parseNullableString(json['vehicleNumber']),
      driverName: _parseNullableString(json['driverName']),
      driverRating: _parseDouble(json['driverRating']),
      pickupAddress: _parseString(json['pickupAddress']),
      dropAddress: _parseString(json['dropAddress']),
      isBookNow: _parseBool(json['isBookNow']),
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'])
          : null,
      rateType: _parseString(json['rateType']),
      estimatedDistanceKm: _parseDouble(json['estimatedDistanceKm']),
      estimatedDurationHr: _parseDouble(json['estimatedDurationHr']),
      baseFare: _parseDouble(json['baseFare']),
      distanceFare: _parseDouble(json['distanceFare']),
      platformFee: _parseDouble(json['platformFee']),
      gstAmount: _parseDouble(json['gstAmount']),
      discountAmount: _parseDouble(json['discountAmount']),
      totalEstimate: _parseDouble(json['totalEstimate']),
      finalAmount: _parseDouble(json['finalAmount']),
      paymentMethod: _parseString(json['paymentMethod']),
      paymentStatus: _parseString(json['paymentStatus']),
      addLoadingHelper: _parseBool(json['addLoadingHelper']),
      addUnloadingHelper: _parseBool(json['addUnloadingHelper']),
      insuranceCoverage: _parseBool(json['insuranceCoverage']),
      returnTripRequired: _parseBool(json['returnTripRequired']),
      specialInstructions: _parseNullableString(json['specialInstructions']),
      createdAt: DateTime.parse(json['createdAt']),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'])
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
    );
  }

  static String _parseString(dynamic v) => v?.toString() ?? '';
  static String? _parseNullableString(dynamic v) => v?.toString();
  static int _parseInt(dynamic v) =>
      v != null ? int.tryParse(v.toString()) ?? 0 : 0;
  static double _parseDouble(dynamic v) =>
      v != null ? double.tryParse(v.toString()) ?? 0.0 : 0.0;
  static bool _parseBool(dynamic v) => v == true || v == 'true' || v == 1;

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      bookingRef: bookingRef,
      status: status,
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      vehicleImagePath: vehicleImagePath,
      vehicleNumber: vehicleNumber,
      driverName: driverName,
      driverRating: driverRating,
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
      totalEstimate: totalEstimate,
      finalAmount: finalAmount,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      addLoadingHelper: addLoadingHelper,
      addUnloadingHelper: addUnloadingHelper,
      insuranceCoverage: insuranceCoverage,
      returnTripRequired: returnTripRequired,
      specialInstructions: specialInstructions,
      createdAt: createdAt,
      acceptedAt: acceptedAt,
      startedAt: startedAt,
      completedAt: completedAt,
      cancelledAt: cancelledAt,
    );
  }
}
