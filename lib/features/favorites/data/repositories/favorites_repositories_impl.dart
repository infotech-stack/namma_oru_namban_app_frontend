import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'package:userapp/features/favorites/domain/entities/favorite_entity.dart';
import 'package:userapp/features/favorites/domain/repositories/favoritesRepository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource _ds;

  FavoritesRepositoryImpl(this._ds);

  @override
  Future<ApiResult<void>> toggleFavorite(int vehicleId) async {
    try {
      await _ds.toggleFavorite(vehicleId);
      return ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<List<FavoriteEntity>>> getFavorites() async {
    try {
      final res = await _ds.getFavorites();

      return ApiResult.success(res.map((e) => e.toEntity()).toList());
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
