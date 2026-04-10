// lib/features/address/domain/usecases/get_addresses_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/entities/address_entity.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/repositories/address_repository.dart';

class GetAddressesUseCase {
  final AddressRepository _repository;
  const GetAddressesUseCase(this._repository);

  Future<ApiResult<List<AddressEntity>>> call() => _repository.getAddresses();
}
