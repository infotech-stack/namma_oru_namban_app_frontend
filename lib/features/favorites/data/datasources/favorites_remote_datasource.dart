import 'package:userapp/core/network/api_constants.dart';
import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/favorites/data/model/favorites_model.dart';

abstract class FavoritesRemoteDataSource {
  Future<void> toggleFavorite(int vehicleId);
  Future<List<FavoriteModel>> getFavorites();
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final ApiService _api;

  FavoritesRemoteDataSourceImpl({ApiService? apiService})
    : _api = apiService ?? ApiService();

  @override
  Future<void> toggleFavorite(int vehicleId) async {
    final result = await _api.post(
      '${ApiConstants.user.favorites}/$vehicleId',
      {},
    );

    if (!result.isSuccess) {
      throw ApiException(message: result.error ?? 'Failed to toggle favorite');
    }
  }

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    final result = await _api.get(ApiConstants.user.favorites);

    if (result.isSuccess && result.data != null) {
      final list = result.data['data']['favorites'] as List;

      return list.map((e) => FavoriteModel.fromJson(e)).toList();
    }

    throw ApiException(message: result.error ?? 'Failed to fetch favorites');
  }
}
