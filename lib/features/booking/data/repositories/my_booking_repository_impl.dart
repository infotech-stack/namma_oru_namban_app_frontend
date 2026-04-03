// lib/features/booking/data/repositories/my_booking_repository_impl.dart
// ════════════════════════════════════════════════════════════════
//  MY BOOKING REPOSITORY IMPL — Data Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking/data/datasources/my_booking_remote_datasource.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_entity.dart';
import 'package:userapp/features/booking/domain/repositories/my_booking_repository.dart';

class MyBookingRepositoryImpl implements MyBookingRepository {
  final MyBookingRemoteDataSource _dataSource;

  MyBookingRepositoryImpl({MyBookingRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? MyBookingRemoteDataSourceImpl();

  @override
  Future<ApiResult<MyBookingsResponseEntity>> getMyBookings({
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _dataSource.getMyBookings(
        limit: limit,
        offset: offset,
      );
      return ApiResult.success(response.toEntity());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }
}
