// lib/features/address/domain/usecases/update_address_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/entities/address_entity.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository _repository;
  const UpdateAddressUseCase(this._repository);

  Future<ApiResult<AddressEntity>> call({
    required int id,
    required String address,
    required bool isDefault,
  }) =>
      _repository.updateAddress(id: id, address: address, isDefault: isDefault);
}
