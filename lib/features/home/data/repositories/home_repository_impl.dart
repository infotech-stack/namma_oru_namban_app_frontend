// ════════════════════════════════════════════════════════════════
//  HOME REPOSITORY IMPLEMENTATION — Data Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/home/data/datasources/home_remote_datasource.dart';
import 'package:userapp/features/home/domain/entities/vehicle_category_entity.dart';
import 'package:userapp/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _dataSource;

  HomeRepositoryImpl({HomeRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? HomeRemoteDataSourceImpl();

  @override
  Future<ApiResult<List<VehicleCategoryEntity>>> getCategories() async {
    try {
      final models = await _dataSource.getCategories();
      final entities = models.map((model) => model.toEntity()).toList();
      return ApiResult.success(entities);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<VehiclesResponseEntity>> getVehicles({
    String? filter,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _dataSource.getVehicles(
        filter: filter,
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

  @override
  Future<ApiResult<VehicleEntity>> getVehicleDetail(int id) async {
    try {
      final vehicle = await _dataSource.getVehicleDetail(id);
      return ApiResult.success(vehicle.toEntity());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }
}
