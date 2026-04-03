// lib/features/booking/unified/data/repositories/booking_repository_impl.dart

import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking_details/data/datasources/booking_remote_datasource.dart';
import 'package:userapp/features/booking_details/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _dataSource;

  BookingRepositoryImpl({BookingRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? BookingRemoteDataSourceImpl();

  @override
  Future<ApiResult<Map<String, dynamic>>> createBooking(
    Map<String, dynamic> params,
  ) async {
    try {
      final data = await _dataSource.createBooking(params);
      return ApiResult.success(data);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getBookingDetail(
    int bookingId,
  ) async {
    try {
      final data = await _dataSource.getBookingDetail(bookingId);
      return ApiResult.success(data);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getUserBookings({
    String? status,
    int? limit = 20,
    int? offset = 0,
  }) async {
    try {
      final data = await _dataSource.getUserBookings(
        status: status,
        limit: limit,
        offset: offset,
      );
      return ApiResult.success(data);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> cancelBooking(int bookingId) async {
    try {
      final data = await _dataSource.cancelBooking(bookingId);
      return ApiResult.success(data);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }
}
