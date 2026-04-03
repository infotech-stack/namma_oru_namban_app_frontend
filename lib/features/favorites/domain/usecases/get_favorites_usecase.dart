// get_favorites_usecase.dart
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/favorites/domain/entities/favorite_entity.dart';
import 'package:userapp/features/favorites/domain/repositories/favoritesRepository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repo;
  GetFavoritesUseCase(this.repo);

  Future<ApiResult<List<FavoriteEntity>>> call() {
    return repo.getFavorites();
  }
}

// toggle_favorite_usecase.dart
class ToggleFavoriteUseCase {
  final FavoritesRepository repo;
  ToggleFavoriteUseCase(this.repo);

  Future<ApiResult<void>> call(int id) {
    return repo.toggleFavorite(id);
  }
}
