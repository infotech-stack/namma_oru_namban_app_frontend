import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/features/favorites/domain/entities/favorite_entity.dart';
import 'package:userapp/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:userapp/core/route/app_routes.dart';

class FavoritesController extends GetxController {
  static FavoritesController get to => Get.find();

  final GetFavoritesUseCase _getFavorites;
  final ToggleFavoriteUseCase _toggleFavorite;

  FavoritesController(this._getFavorites, this._toggleFavorite);

  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final selectedCategoryIndex = 0.obs;

  /// ✅ SINGLE SOURCE OF TRUTH
  final favorites = <FavoriteEntity>[].obs;

  final isLoading = false.obs;

  // ── Categories ─────────────────────────────
  final categories = <Map<String, dynamic>>[
    {
      'labelKey': 'fav_cat_all',
      'icon': Icons.grid_view_rounded,
      'filterKey': 'all',
    },
    {
      'labelKey': 'fav_cat_car',
      'icon': Icons.directions_car_rounded,
      'filterKey': 'car',
    },
    {
      'labelKey': 'fav_cat_jcb',
      'icon': Icons.construction_rounded,
      'filterKey': 'jcb',
    },
    {
      'labelKey': 'fav_cat_lorry',
      'icon': Icons.local_shipping_rounded,
      'filterKey': 'lorry',
    },
    {
      'labelKey': 'fav_cat_bus',
      'icon': Icons.directions_bus_filled_rounded,
      'filterKey': 'bus',
    },
    {
      'labelKey': 'fav_cat_mini_bus',
      'icon': Icons.directions_bus_rounded,
      'filterKey': 'mini_bus',
    },
    {
      'labelKey': 'fav_cat_tataace',
      'icon': Icons.airport_shuttle_rounded,
      'filterKey': 'tataace',
    },
    {
      'labelKey': 'fav_cat_tractor',
      'icon': Icons.agriculture_outlined,
      'filterKey': 'tractor',
    },
    {
      'labelKey': 'fav_cat_agri',
      'icon': Icons.agriculture,
      'filterKey': 'agri',
    },
  ];

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    fetchFavorites();
  }

  // ════════════════════════════════════════════
  // ✅ FETCH
  // ════════════════════════════════════════════
  Future<void> fetchFavorites() async {
    isLoading.value = true;

    final result = await _getFavorites();

    if (result.isSuccess && result.data != null) {
      favorites.assignAll(result.data!);
    }

    isLoading.value = false;
  }

  // ════════════════════════════════════════════
  // ✅ TOGGLE (API + UI sync)
  // ════════════════════════════════════════════
  Future<void> toggleFavorite(FavoriteEntity vehicle) async {
    final exists = favorites.any((e) => e.id == vehicle.id);

    /// 🔥 OPTIMISTIC UI UPDATE
    if (exists) {
      favorites.removeWhere((e) => e.id == vehicle.id);
    } else {
      favorites.add(vehicle);
    }

    final result = await _toggleFavorite(vehicle.id);

    /// ❌ rollback if API fail
    if (!result.isSuccess) {
      if (exists) {
        favorites.add(vehicle);
      } else {
        favorites.removeWhere((e) => e.id == vehicle.id);
      }
    }
  }

  // ════════════════════════════════════════════
  // ✅ CHECK (for ❤️)
  // ════════════════════════════════════════════
  bool isFavorite(int id) {
    return favorites.any((e) => e.id == id);
  }

  // ── Filtered list ───────────────────────────
  List<FavoriteEntity> get filteredFavorites {
    final key = categories[selectedCategoryIndex.value]['filterKey'] as String;

    var list = key == 'all'
        ? favorites
        : favorites.where((v) => v.categoryKey == key).toList();

    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((v) => v.nameKey.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  int get favoritesCount => favorites.length;

  bool get isCurrentCategoryEmpty {
    final key = categories[selectedCategoryIndex.value]['filterKey'] as String;
    if (key == 'all') return favorites.isEmpty;
    return !favorites.any((v) => v.categoryKey == key);
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    searchController.clear();
  }

  // ── REMOVE
  void onRemoveFavorite(FavoriteEntity vehicle) {
    Get.dialog(
      AlertDialog(
        title: Text('fav_remove_title'.tr),
        content: Text('${'fav_remove_subtitle'.tr} ${vehicle.nameKey}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('fav_cancel'.tr)),
          TextButton(
            onPressed: () async {
              await toggleFavorite(vehicle); // ✅ FIXED
              Get.back();
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ── NAVIGATION
  void onBookNow(FavoriteEntity vehicle) {
    Get.toNamed(
      Routes.bookingDetails,
      arguments: {
        'name': vehicle.nameKey,
        'rating': vehicle.rating,
        'capacity': vehicle.capacity,
        'fare': vehicle.fare,
        'eta': vehicle.eta,
        'imagePath': vehicle.imagePath,
      },
    );
  }

  Future<void> refreshFavorites() async {
    if (isLoading.value) return;

    await fetchFavorites();
  }

  @override
  void onReady() {
    super.onReady();
    refreshFavorites();
  }

  void onVehicleDetails(FavoriteEntity vehicle) {
    Get.toNamed(
      Routes.vehDetails,
      arguments: {
        'name': vehicle.nameKey,
        'rating': vehicle.rating,
        'capacity': vehicle.capacity,
        'fare': vehicle.fare,
        'eta': vehicle.eta,
        'imagePath': vehicle.imagePath,
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
