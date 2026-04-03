import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/home/domain/entities/vehicle_category_entity.dart';
import 'package:userapp/features/home/domain/repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository _repository;

  const GetCategoriesUseCase(this._repository);

  Future<ApiResult<List<VehicleCategoryEntity>>> call() async {
    return _repository.getCategories();
  }
}
