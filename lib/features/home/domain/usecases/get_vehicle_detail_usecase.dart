// lib/features/home/domain/usecases/get_vehicle_detail_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/home/domain/entities/vehicle_category_entity.dart';
import 'package:userapp/features/home/domain/repositories/home_repository.dart';

class GetVehicleDetailUseCase {
  final HomeRepository repository;

  GetVehicleDetailUseCase(this.repository);

  Future<ApiResult<VehicleEntity>> call(int id) async {
    return await repository.getVehicleDetail(id);
  }
}
