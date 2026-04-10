// lib/features/address/domain/usecases/create_address_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/entities/address_entity.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/repositories/address_repository.dart';

class CreateAddressUseCase {
  final AddressRepository _repository;
  const CreateAddressUseCase(this._repository);

  Future<ApiResult<AddressEntity>> call({
    required String label,
    required String address,
    required double lat,
    required double lng,
    required bool isDefault,
  }) => _repository.createAddress(
    label: label,
    address: address,
    lat: lat,
    lng: lng,
    isDefault: isDefault,
  );
}
