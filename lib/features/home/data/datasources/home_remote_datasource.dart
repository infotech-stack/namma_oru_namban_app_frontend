// lib/features/home/data/datasources/home_remote_datasource.dart
// ════════════════════════════════════════════════════════════════
//  HOME REMOTE DATASOURCE — Data Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_constants.dart';
import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/home/data/model/vehicle_category_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<VehicleCategoryModel>> getCategories();
  Future<VehiclesResponseModel> getVehicles({
    String? filter,
    int? limit,
    int? offset,
  });
  Future<VehicleModel> getVehicleDetail(int id);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService _api;

  HomeRemoteDataSourceImpl({ApiService? apiService})
    : _api = apiService ?? ApiService();

  // ── Get Categories ─────────────────────────────────────────────
  // GET /api/v1/user/home/categories
  @override
  Future<List<VehicleCategoryModel>> getCategories() async {
    try {
      final result = await _api.get(ApiConstants.user.homeCategories);

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;

        // Extract the 'data' array from the response
        final categoriesList = responseData['data'] as List? ?? [];

        return categoriesList
            .map(
              (json) =>
                  VehicleCategoryModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }

      throw ApiException(
        message: result.error ?? 'Failed to fetch categories',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  // ── Get Vehicles ───────────────────────────────────────────────
  // GET /api/v1/user/home/vehicles?filter={filter}&limit={limit}&offset={offset}
  @override
  Future<VehiclesResponseModel> getVehicles({
    String? filter,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (filter != null && filter != 'all') queryParams['filter'] = filter;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final result = await _api.get(
        ApiConstants.user.homeVehicles,
        queryParams: queryParams,
      );

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;

        // Extract the 'data' object from the response
        final vehiclesData =
            responseData['data'] as Map<String, dynamic>? ?? {};

        return VehiclesResponseModel.fromJson(vehiclesData);
      }

      throw ApiException(
        message: result.error ?? 'Failed to fetch vehicles',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      print('Error fetching vehicles: $e');
      rethrow;
    }
  }

  // ── Get Vehicle Detail ─────────────────────────────────────────
  // GET /api/v1/user/home/vehicles/:id
  @override
  Future<VehicleModel> getVehicleDetail(int id) async {
    try {
      final result = await _api.get('${ApiConstants.user.vehicleDetail}/$id');

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;

        // Extract the 'data' object from the response
        final vehicleData = responseData['data'] as Map<String, dynamic>? ?? {};

        return VehicleModel.fromJson(vehicleData);
      }

      throw ApiException(
        message: result.error ?? 'Failed to fetch vehicle details',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      print('Error fetching vehicle detail: $e');
      rethrow;
    }
  }
}
