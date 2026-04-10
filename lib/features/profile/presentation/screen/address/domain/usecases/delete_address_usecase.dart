import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/repositories/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository _repository;
  const DeleteAddressUseCase(this._repository);

  Future<ApiResult<void>> call(int id) => _repository.deleteAddress(id);
}
