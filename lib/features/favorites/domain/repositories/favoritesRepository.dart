import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/favorites/domain/entities/favorite_entity.dart';

abstract class FavoritesRepository {
  Future<ApiResult<void>> toggleFavorite(int vehicleId);
  Future<ApiResult<List<FavoriteEntity>>> getFavorites();
}
