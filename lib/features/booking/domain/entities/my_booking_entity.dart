// lib/features/booking/domain/entities/my_booking_entity.dart
// ════════════════════════════════════════════════════════════════
//  MY BOOKING ENTITY — Domain Layer
// ════════════════════════════════════════════════════════════════

class MyBookingEntity {
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

  const MyBookingEntity({
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

  // ── Computed helpers (same as model) ─────────────────────────
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
}

// ── Response Entity ───────────────────────────────────────────────────────────

class MyBookingsResponseEntity {
  final List<MyBookingEntity> bookings;
  final int total;
  final int limit;
  final int offset;

  const MyBookingsResponseEntity({
    required this.bookings,
    required this.total,
    required this.limit,
    required this.offset,
  });
}
