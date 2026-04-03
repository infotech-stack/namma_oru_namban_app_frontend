// lib/features/booking/unified/data/datasources/booking_remote_datasource.dart

import 'package:userapp/core/network/api_constants.dart';
import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_service.dart';

abstract class BookingRemoteDataSource {
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> params);
  Future<Map<String, dynamic>> getBookingDetail(int bookingId);
  Future<Map<String, dynamic>> getUserBookings({
    String? status,
    int? limit,
    int? offset,
  });
  Future<Map<String, dynamic>> cancelBooking(int bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiService _api;

  BookingRemoteDataSourceImpl({ApiService? apiService})
    : _api = apiService ?? ApiService();

  @override
  Future<Map<String, dynamic>> createBooking(
    Map<String, dynamic> params,
  ) async {
    try {
      // ✅ Correct: post(path, data) - data is second positional argument
      final result = await _api.post(
        ApiConstants.user.bookings,
        params, // 👈 Second positional argument
      );

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        // API returns: { success: true, message: "...", data: {...} }
        final data = responseData['data'] as Map<String, dynamic>? ?? {};
        return data;
      }

      throw ApiException(
        message: result.error ?? 'Failed to create booking',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Unexpected error: ${e.toString()}',
        type: ApiErrorType.unknown,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getBookingDetail(int bookingId) async {
    try {
      final result = await _api.get('${ApiConstants.user.bookings}/$bookingId');

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ?? {};
        return data;
      }

      throw ApiException(
        message: result.error ?? 'Failed to fetch booking details',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Unexpected error: ${e.toString()}',
        type: ApiErrorType.unknown,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getUserBookings({
    String? status,
    int? limit = 20,
    int? offset = 0,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null && status != 'all') queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final result = await _api.get(
        ApiConstants.user.bookings,
        queryParams: queryParams,
      );

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ?? {};
        return data;
      }

      throw ApiException(
        message: result.error ?? 'Failed to fetch bookings',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Unexpected error: ${e.toString()}',
        type: ApiErrorType.unknown,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    try {
      // ✅ Correct: patch(path, data) - data is second positional argument
      // For cancel, we don't need to send any data, so pass empty map
      final result = await _api.patch(
        '${ApiConstants.user.bookings}/$bookingId/cancel',
        {}, // 👈 Second positional argument (empty body)
      );

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ?? {};
        return data;
      }

      throw ApiException(
        message: result.error ?? 'Failed to cancel booking',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Unexpected error: ${e.toString()}',
        type: ApiErrorType.unknown,
      );
    }
  }
}
