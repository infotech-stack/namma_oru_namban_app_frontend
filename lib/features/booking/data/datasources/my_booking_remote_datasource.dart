// lib/features/booking/data/datasources/my_booking_remote_datasource.dart
// ════════════════════════════════════════════════════════════════
//  MY BOOKING REMOTE DATASOURCE — Data Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_constants.dart';
import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/booking/data/model/my_booking_model.dart';

abstract class MyBookingRemoteDataSource {
  Future<MyBookingsResponseModel> getMyBookings({int? limit, int? offset});
}

class MyBookingRemoteDataSourceImpl implements MyBookingRemoteDataSource {
  final ApiService _api;

  MyBookingRemoteDataSourceImpl({ApiService? apiService})
    : _api = apiService ?? ApiService();

  // ── GET /api/v1/user/bookings ──────────────────────────────────
  @override
  Future<MyBookingsResponseModel> getMyBookings({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final result = await _api.get(
        ApiConstants.user.bookings,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;

        // Extract the 'data' object from the response
        final bookingsData =
            responseData['data'] as Map<String, dynamic>? ?? {};

        return MyBookingsResponseModel.fromJson(bookingsData);
      }

      throw ApiException(
        message: result.error ?? 'Failed to fetch bookings',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      print('Error fetching bookings: $e');
      rethrow;
    }
  }
}
