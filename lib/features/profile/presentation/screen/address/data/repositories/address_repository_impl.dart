// lib/features/address/data/repositories/address_repository_impl.dart

import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/profile/presentation/screen/address/data/datasources/address_remote_datasource.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/entities/address_entity.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource _dataSource;

  AddressRepositoryImpl({AddressRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? AddressRemoteDataSourceImpl();

  @override
  Future<ApiResult<List<AddressEntity>>> getAddresses() async {
    try {
      final models = await _dataSource.getAddresses();
      return ApiResult.success(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<AddressEntity>> createAddress({
    required String label,
    required String address,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    try {
      final model = await _dataSource.createAddress(
        label: label,
        address: address,
        lat: lat,
        lng: lng,
        isDefault: isDefault,
      );
      return ApiResult.success(model.toEntity());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<AddressEntity>> updateAddress({
    required int id,
    required String address,
    required bool isDefault,
  }) async {
    try {
      final model = await _dataSource.updateAddress(
        id: id,
        address: address,
        isDefault: isDefault,
      );
      return ApiResult.success(model.toEntity());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<void>> deleteAddress(int id) async {
    try {
      await _dataSource.deleteAddress(id);
      return ApiResult.success(null);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }
}
