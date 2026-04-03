// lib/features/booking/unified/domain/repositories/booking_repository.dart

import 'package:userapp/core/network/api_result.dart';

abstract class BookingRepository {
  Future<ApiResult<Map<String, dynamic>>> createBooking(
    Map<String, dynamic> params,
  );
  Future<ApiResult<Map<String, dynamic>>> getBookingDetail(int bookingId);
  Future<ApiResult<Map<String, dynamic>>> getUserBookings({
    String? status,
    int? limit,
    int? offset,
  });
  Future<ApiResult<Map<String, dynamic>>> cancelBooking(int bookingId);
}
