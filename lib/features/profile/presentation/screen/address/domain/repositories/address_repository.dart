// lib/features/address/domain/repositories/address_repository.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/entities/address_entity.dart';

abstract class AddressRepository {
  Future<ApiResult<List<AddressEntity>>> getAddresses();

  Future<ApiResult<AddressEntity>> createAddress({
    required String label,
    required String address,
    required double lat,
    required double lng,
    required bool isDefault,
  });

  Future<ApiResult<AddressEntity>> updateAddress({
    required int id,
    required String address,
    required bool isDefault,
  });

  Future<ApiResult<void>> deleteAddress(int id);
}
