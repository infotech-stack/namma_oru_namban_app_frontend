// lib/features/favorites/presentation/controller/favorites_controller.dart
//
// ════════════════════════════════════════════════════════════════
//  FAVORITES CONTROLLER — permanent: true (singleton)
//
//  WHY permanent:
//    HomeScreen + FavoritesScreen both share this controller.
//    permanent: true ensures it stays alive across navigation.
//    Heart toggle on HomeScreen instantly reflects on FavScreen.
//
//  FLOW:
//    HomeScreen card heart tap
//      → FavoritesController.toggleFavorite(vehicle)
//      → isFavorite(vehicle.id) → true/false
//      → Heart icon red/grey reactively
//
//    FavoritesScreen
//      → filteredFavorites — shows only saved vehicles
//      → Remove tap → toggleFavorite → removed from HomeScreen too
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/constants/app_images.dart';

// ── Favorite vehicle model ─────────────────────────────────────
class FavoriteVehicle {
  final String id;
  final String nameKey;
  final String rating;
  final String capacity;
  final String fare;
  final String eta;
  final String categoryKey;
  final String availabilityStatus;
  String? imagePath;

  FavoriteVehicle({
    required this.id,
    required this.nameKey,
    required this.rating,
    required this.capacity,
    required this.fare,
    required this.eta,
    required this.categoryKey,
    this.availabilityStatus = 'available',
    this.imagePath,
  });
}

class FavoritesController extends GetxController {
  // ── Singleton access ───────────────────────────────────────
  static FavoritesController get to => Get.find();

  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  // ── Selected category filter ───────────────────────────────
  final selectedCategoryIndex = 0.obs;

  // ── Saved favorites — RxList (reactive) ───────────────────
  // Key: vehicle id — Value: FavoriteVehicle
  final _favoriteMap = <String, FavoriteVehicle>{}.obs;

  // ── Categories ─────────────────────────────────────────────
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
  }

  // ════════════════════════════════════════════════════════════
  //  CORE — Toggle favorite (add/remove)
  //  Called from HomeScreen heart button tap
  // ════════════════════════════════════════════════════════════
  void toggleFavorite(FavoriteVehicle vehicle) {
    if (_favoriteMap.containsKey(vehicle.id)) {
      _favoriteMap.remove(vehicle.id); // ← remove
    } else {
      _favoriteMap[vehicle.id] = vehicle; // ← add
    }
  }

  // ════════════════════════════════════════════════════════════
  //  CHECK — Is vehicle favorited?
  //  Used in HomeScreen to show red/grey heart
  //  Wrap in Obx to react to changes
  // ════════════════════════════════════════════════════════════
  bool isFavorite(String vehicleId) => _favoriteMap.containsKey(vehicleId);

  // ── All favorites as list ──────────────────────────────────
  List<FavoriteVehicle> get _allFavorites => _favoriteMap.values.toList();

  // ── Filtered list (category + search) ─────────────────────
  List<FavoriteVehicle> get filteredFavorites {
    final key = categories[selectedCategoryIndex.value]['filterKey'] as String;
    var list = key == 'all'
        ? _allFavorites
        : _allFavorites.where((v) => v.categoryKey == key).toList();

    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((v) => v.nameKey.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  // ── Total favorites count (for badge on nav bar) ──────────
  int get favoritesCount => _favoriteMap.length;

  // ── Category has favorites? ────────────────────────────────
  bool get isCurrentCategoryEmpty {
    final key = categories[selectedCategoryIndex.value]['filterKey'] as String;
    if (key == 'all') return _favoriteMap.isEmpty;
    return !_allFavorites.any((v) => v.categoryKey == key);
  }

  // ── Select category ────────────────────────────────────────
  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    searchController.clear();
  }

  // ── Remove with confirmation dialog ───────────────────────
  void onRemoveFavorite(FavoriteVehicle vehicle) {
    Get.dialog(
      AlertDialog(
        title: Text('fav_remove_title'.tr),
        content: Text('${'fav_remove_subtitle'.tr} ${vehicle.nameKey}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('fav_cancel'.tr)),
          TextButton(
            onPressed: () {
              _favoriteMap.remove(vehicle.id);
              Get.back();
            },
            child: Text(
              'fav_remove_btn'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ── Book Now ───────────────────────────────────────────────
  void onBookNow(FavoriteVehicle vehicle) {
    Get.toNamed(
      Routes.bookingDetails,
      arguments: {
        'name': vehicle.nameKey,
        'rating': vehicle.rating,
        'capacity': vehicle.capacity,
        'fare': vehicle.fare,
        'eta': vehicle.eta,
        'imagePath': vehicle.imagePath,
        'distance': '3.2',
        'tripsCompleted': '120',
      },
    );
  }

  // ── Vehicle details ────────────────────────────────────────
  void onVehicleDetails(FavoriteVehicle vehicle) {
    Get.toNamed(
      Routes.vehDetails,
      arguments: {
        'name': vehicle.nameKey,
        'rating': vehicle.rating,
        'capacity': vehicle.capacity,
        'fare': vehicle.fare,
        'eta': vehicle.eta,
        'imagePath': vehicle.imagePath,
        'distance': '3.2',
        'tripsCompleted': '120',
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
