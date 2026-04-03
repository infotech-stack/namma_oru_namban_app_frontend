// lib/features/booking/data/repositories/my_booking_detail_repository_impl.dart
// ════════════════════════════════════════════════════════════════
//  MY BOOKING DETAIL REPOSITORY IMPL — Data Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking/data/datasources/my_booking_detail_remote_datasource.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_detail_entity.dart';
import 'package:userapp/features/booking/domain/repositories/my_booking_detail_repository.dart';

class MyBookingDetailRepositoryImpl implements MyBookingDetailRepository {
  final MyBookingDetailRemoteDataSource _dataSource;

  MyBookingDetailRepositoryImpl({MyBookingDetailRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? MyBookingDetailRemoteDataSourceImpl();

  @override
  Future<ApiResult<MyBookingDetailEntity>> getBookingDetail(int id) async {
    try {
      final model = await _dataSource.getBookingDetail(id);
      return ApiResult.success(model.toEntity());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }
}
