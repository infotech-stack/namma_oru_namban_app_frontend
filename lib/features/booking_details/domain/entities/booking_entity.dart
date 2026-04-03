// lib/features/booking/unified/domain/entities/booking_entity.dart

class BookingEntity {
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

  const BookingEntity({
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
}
