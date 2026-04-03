// lib/features/driver/bookings/data/model/driver_booking_model.dart

class DriverBookingModel {
  final int id;
  final String bookingRef;
  final String status;
  final String vehicleName;
  final String pickupAddress;
  final String dropAddress;
  final double? totalEstimate;
  final String? paymentMethod;
  final String userName;
  final String userMobile;
  final DateTime createdAt;

  const DriverBookingModel({
    required this.id,
    required this.bookingRef,
    required this.status,
    required this.vehicleName,
    required this.pickupAddress,
    required this.dropAddress,
    this.totalEstimate,
    this.paymentMethod,
    required this.userName,
    required this.userMobile,
    required this.createdAt,
  });

  String get displayAmount {
    if (totalEstimate == null) return '—';
    return '₹${totalEstimate!.toStringAsFixed(0)}';
  }

  bool get isActive =>
      status == 'pending' || status == 'accepted' || status == 'ongoing';
}

// ── Dummy Data ────────────────────────────────────────────────────────────────

final List<DriverBookingModel> dummyDriverBookings = [
  DriverBookingModel(
    id: 9,
    bookingRef: '#BK20260412',
    status: 'ongoing',
    vehicleName: 'Container Truck',
    pickupAddress: 'Phase 2, Anna Nagar, Chennai – 600040',
    dropAddress: 'Ambattur Industrial Estate, Chennai – 600058',
    totalEstimate: 4250,
    paymentMethod: 'Cash',
    userName: 'Aravind Kumar',
    userMobile: '+919876543210',
    createdAt: DateTime.now(),
  ),
  DriverBookingModel(
    id: 10,
    bookingRef: '#BK20260413',
    status: 'pending',
    vehicleName: 'Mini Truck',
    pickupAddress: 'T. Nagar, Chennai – 600017',
    dropAddress: 'Porur, Chennai – 600116',
    totalEstimate: 1800,
    paymentMethod: 'Cash',
    userName: 'Priya Selvan',
    userMobile: '+919988776655',
    createdAt: DateTime.now().add(const Duration(hours: 3)),
  ),
  DriverBookingModel(
    id: 7,
    bookingRef: '#BK20260410',
    status: 'completed',
    vehicleName: 'Container Truck',
    pickupAddress: 'Vadapalani, Chennai – 600026',
    dropAddress: 'Sholinganallur, Chennai – 600119',
    totalEstimate: 3100,
    paymentMethod: 'UPI',
    userName: 'Suresh Babu',
    userMobile: '+919123456789',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  DriverBookingModel(
    id: 6,
    bookingRef: '#BK20260408',
    status: 'rejected',
    vehicleName: 'Mini Truck',
    pickupAddress: 'Velachery, Chennai – 600042',
    dropAddress: 'Guindy, Chennai – 600032',
    totalEstimate: 950,
    paymentMethod: 'Cash',
    userName: 'Karthik Raja',
    userMobile: '+919000011112',
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
];
