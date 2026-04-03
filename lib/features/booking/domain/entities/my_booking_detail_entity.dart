// ════════════════════════════════════════════════════════════════
//  MY BOOKING DETAIL ENTITY — Domain Layer
// ════════════════════════════════════════════════════════════════

class MyBookingDetailEntity {
  final int id;
  final String bookingRef;
  final String status;
  final int vehicleId;
  final String vehicleName;
  final String vehicleCategoryName;
  final String vehicleCategorySlug;
  final String? vehicleImagePath;
  final String basePrice;
  final String pricingModel;
  final int driverId;
  final String driverName;
  final String? driverPhoto;
  final String driverRating;
  final String driverMobile;
  final String pickupAddress;
  final String dropAddress;
  final bool isBookNow;
  final DateTime? scheduledAt;
  final String rateType;
  final String estimatedDistanceKm;
  final String estimatedDurationHr;
  final String baseFare;
  final String distanceFare;
  final String platformFee;
  final String gstAmount;
  final String discountAmount;
  final String? promoCode;
  final String promoDiscount;
  final String totalEstimate;
  final String? finalAmount;
  final bool addLoadingHelper;
  final bool addUnloadingHelper;
  final bool insuranceCoverage;
  final bool returnTripRequired;
  final String paymentMethod;
  final String paymentStatus;
  final String? specialInstructions;
  final String? driverRejectionReason;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancelledBy;
  final List<BookingStatusHistoryEntity> statusHistory;

  const MyBookingDetailEntity({
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
}

// ── Status History Entity ─────────────────────────────────────────────────────

class BookingStatusHistoryEntity {
  final String? from;
  final String to;
  final String by;
  final String note;
  final DateTime timestamp;

  const BookingStatusHistoryEntity({
    this.from,
    required this.to,
    required this.by,
    required this.note,
    required this.timestamp,
  });
}
