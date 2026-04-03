// lib/features/booking/domain/repositories/my_booking_repository.dart
// ════════════════════════════════════════════════════════════════
//  MY BOOKING REPOSITORY — Domain Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_entity.dart';

abstract class MyBookingRepository {
  Future<ApiResult<MyBookingsResponseEntity>> getMyBookings({
    int? limit,
    int? offset,
  });
}
