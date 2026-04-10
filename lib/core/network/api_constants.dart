// lib/core/network/api_constants.dart
// ════════════════════════════════════════════════════════════════
//  API CONSTANTS — USER APP ONLY
//  Base URL set in EnvConfig: http://localhost:3000/api/v1
//  All paths below are relative to base URL
// ════════════════════════════════════════════════════════════════

class ApiConstants {
  ApiConstants._();

  static const auth = _UserAuthEndpoints();
  static const user = _UserEndpoints();
  static const vehicle = _VehicleEndpoints();
}

// ════════════════════════════════════════════════════════════════
//  USER AUTH ENDPOINTS
// ════════════════════════════════════════════════════════════════
class _UserAuthEndpoints {
  const _UserAuthEndpoints();

  String get sendOtp => '/user/auth/send-otp';
  String get verifyOtp => '/user/auth/verify-otp';
  String get registerSendOtp => '/user/auth/register/send-otp';
}

// ════════════════════════════════════════════════════════════════
//  USER APP ENDPOINTS
// ════════════════════════════════════════════════════════════════
class _UserEndpoints {
  const _UserEndpoints();

  // ── Home ──────────────────────────────────────────────────────
  String get home => '/user/home';

  // ── Vehicles ──────────────────────────────────────────────────
  // String get vehicles => '/user/vehicles';
  // String get nearbyVehicles => '/user/vehicles/nearby';
  // String get featuredVehicles => '/user/vehicles/featured';
  // String get searchVehicles => '/user/vehicles/search';
  //String vehicleDetail(String id) => '/user/vehicles/$id';
  String get homeCategories => '/user/home/categories';
  String get homeVehicles => '/user/home/vehicles';
  String get vehicleDetail => '/user/home/vehicles'; // + /{id}

  String get carList => '/user/vehicles/car';
  String get busList => '/user/vehicles/bus';
  String get jcbList => '/user/vehicles/jcb';
  String get lorryList => '/user/vehicles/lorry';
  String get tataAceList => '/user/vehicles/tata-ace';
  String get tractorList => '/user/vehicles/tractor';
  String get agriList => '/user/vehicles/agri';

  // ── Bookings ──────────────────────────────────────────────────
  String get bookings => '/user/bookings';
  String get bookingHistory => '/user/bookings/history';
  String bookingDetail(String id) => '/user/bookings/$id';
  String cancelBooking(String id) => '/user/bookings/$id/cancel';

  String get createCarBooking => '/user/bookings/car';
  String get createBusBooking => '/user/bookings/bus';
  String get createJcbBooking => '/user/bookings/jcb';
  String get createLorryBooking => '/user/bookings/lorry';
  String get createTataBooking => '/user/bookings/tata-ace';
  String get createTractorBooking => '/user/bookings/tractor';
  String get createAgriBooking => '/user/bookings/agri';

  // ── Favorites ─────────────────────────────────────────────────
  // String get favorites => '/user/favorites';
  // String get addFavorite => '/user/favorites/add';
  String get favorites => '/user/favorites';
  String removeFavorite(String id) => '/user/favorites/$id/remove';

  // ── Reviews ───────────────────────────────────────────────────
  String vehicleReviews(String vehicleId) => '/user/reviews/$vehicleId';
  String get addReview => '/user/reviews/add';

  // ── Notifications ─────────────────────────────────────────────
  String get notifications => '/user/notifications';
  String get markAllRead => '/user/notifications/read-all';
  String markRead(String id) => '/user/notifications/$id/read';

  // Address
  String get addresses => '/user/addresses';
  String addressById(int id) => '/user/addresses/$id';
}

// ════════════════════════════════════════════════════════════════
//  VEHICLE ENDPOINTS (shared)
// ════════════════════════════════════════════════════════════════
class _VehicleEndpoints {
  const _VehicleEndpoints();

  String detail(String id) => '/vehicles/$id';
  String reviews(String id) => '/vehicles/$id/reviews';
}
