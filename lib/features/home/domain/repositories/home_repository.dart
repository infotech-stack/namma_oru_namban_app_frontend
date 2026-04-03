import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/home/domain/entities/vehicle_category_entity.dart';

abstract class HomeRepository {
  Future<ApiResult<List<VehicleCategoryEntity>>> getCategories();
  Future<ApiResult<VehiclesResponseEntity>> getVehicles({
    String? filter,
    int? limit,
    int? offset,
  });
  Future<ApiResult<VehicleEntity>> getVehicleDetail(int id);
}
