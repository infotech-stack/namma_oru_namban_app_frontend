import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/home/domain/entities/vehicle_category_entity.dart';
import 'package:userapp/features/home/domain/repositories/home_repository.dart';

class GetVehiclesUseCase {
  final HomeRepository _repository;

  const GetVehiclesUseCase(this._repository);

  Future<ApiResult<VehiclesResponseEntity>> call({
    String? filter,
    int? limit,
    int? offset,
  }) async {
    // Validation
    if (limit != null && limit <= 0) {
      return ApiResult.failure('Limit must be greater than 0');
    }
    if (offset != null && offset < 0) {
      return ApiResult.failure('Offset must be 0 or greater');
    }

    return _repository.getVehicles(
      filter: filter,
      limit: limit ?? 20,
      offset: offset ?? 0,
    );
  }
}
