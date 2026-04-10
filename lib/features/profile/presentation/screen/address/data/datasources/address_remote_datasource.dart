// lib/features/address/data/datasources/address_remote_datasource.dart

import 'package:userapp/core/network/api_constants.dart';
import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/profile/presentation/screen/address/data/model/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> createAddress({
    required String label,
    required String address,
    required double lat,
    required double lng,
    required bool isDefault,
  });
  Future<AddressModel> updateAddress({
    required int id,
    required String address,
    required bool isDefault,
  });
  Future<void> deleteAddress(int id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiService _api;

  AddressRemoteDataSourceImpl({ApiService? apiService})
    : _api = apiService ?? ApiService();

  // ── GET /user/addresses ───────────────────────────────────────
  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final result = await _api.get(ApiConstants.user.addresses);

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        final list = responseData['data'] as List? ?? [];
        return list
            .whereType<Map<String, dynamic>>()
            .map(AddressModel.fromJson)
            .toList();
      }

      throw ApiException(
        message: result.error ?? 'Failed to fetch addresses',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ── POST /user/addresses ──────────────────────────────────────
  @override
  Future<AddressModel> createAddress({
    required String label,
    required String address,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    try {
      final result = await _api.post(ApiConstants.user.addresses, {
        'label': label,
        'address': address,
        'lat': lat,
        'lng': lng,
        'isDefault': isDefault,
      });

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        // Check body success flag (e.g. max 5 addresses error)
        if (responseData['success'] == false) {
          throw ApiException(
            message:
                responseData['message'] as String? ??
                'Failed to create address',
          );
        }
        final data = responseData['data'] as Map<String, dynamic>;
        return AddressModel.fromJson(data);
      }

      // Extract message from body on failure
      final body = result.data as Map<String, dynamic>?;
      throw ApiException(
        message:
            body?['message'] as String? ??
            result.error ??
            'Failed to create address',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ── PUT /user/addresses/:id ───────────────────────────────────
  @override
  Future<AddressModel> updateAddress({
    required int id,
    required String address,
    required bool isDefault,
  }) async {
    try {
      final result = await _api.put(ApiConstants.user.addressById(id), {
        'address': address,
        'isDefault': isDefault,
      });

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>;
        return AddressModel.fromJson(data);
      }

      throw ApiException(
        message: result.error ?? 'Failed to update address',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ── DELETE /user/addresses/:id ────────────────────────────────
  @override
  Future<void> deleteAddress(int id) async {
    try {
      final result = await _api.delete(ApiConstants.user.addressById(id));

      if (!result.isSuccess) {
        throw ApiException(
          message: result.error ?? 'Failed to delete address',
          type: result.exception?.type ?? ApiErrorType.unknown,
          statusCode: result.exception?.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
