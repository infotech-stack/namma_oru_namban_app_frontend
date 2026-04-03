// lib/features/home/presentation/controller/home_controller.dart
// Updated with Unified Vehicle Detail Navigation

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/storage/hive_service.dart';
import 'package:userapp/features/favorites/domain/entities/favorite_entity.dart';
import 'package:userapp/features/home/domain/entities/vehicle_category_entity.dart';
import 'package:userapp/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:userapp/features/home/domain/usecases/get_vehicles_usecase.dart';

class HomeController extends GetxController {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetVehiclesUseCase _getVehiclesUseCase;

  HomeController(this._getCategoriesUseCase, this._getVehiclesUseCase);

  @override
  void onInit() {
    super.onInit();
    AppLogger.info('HomeController → onInit');
    loadUserFromHive();
    loadInitialData();
    searchFocusNode.addListener(() {
      isSearchFocused.value = searchFocusNode.hasFocus;
    });
    // 🔥 Listen to search changes
    searchController.addListener(_onSearchChanged);
    final args = Get.arguments;
    if (args is int && currentNavIndex.value == 0) {
      currentNavIndex.value = args;
    }
  }

  // ── Reactive States ───────────────────────────────────────────
  final searchController = TextEditingController();
  final userName = ''.obs;
  final currentNavIndex = 0.obs;
  final selectedCategoryIndex = 0.obs;
  final RxString searchQuery = ''.obs;

  // API States
  final RxList<VehicleCategoryEntity> categories =
      <VehicleCategoryEntity>[].obs;
  final RxList<VehicleEntity> vehicles = <VehicleEntity>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingVehicles = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxInt totalVehicles = 0.obs;
  final RxBool hasMore = true.obs;

  final int pageSize = 20;

  // ── Load Initial Data ─────────────────────────────────────────
  Future<void> loadInitialData() async {
    AppLogger.info('HomeController → loadInitialData: start');
    await Future.wait([fetchCategories(), fetchVehicles(reset: true)]);
    AppLogger.info('HomeController → loadInitialData: done');
  }

  // ── Fetch Categories from API ─────────────────────────────────
  Future<void> fetchCategories() async {
    AppLogger.info('HomeController → fetchCategories: start');
    isLoadingCategories.value = true;
    errorMessage.value = '';

    final result = await _getCategoriesUseCase();

    if (result.isSuccess && result.data != null) {
      categories.assignAll(result.data!);
      AppLogger.info(
        'HomeController → fetchCategories: success — ${result.data!.length} categories loaded',
      );
    } else {
      final err = result.error ?? 'Failed to load categories';
      errorMessage.value = err;
      AppLogger.error('HomeController → fetchCategories: FAILED — $err');
    }

    isLoadingCategories.value = false;
  }

  //---------Search fields---------------
  Timer? _debounce;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = searchController.text.trim().toLowerCase();
    });
  }

  // ── Fetch Vehicles from API ───────────────────────────────────
  Future<void> fetchVehicles({bool reset = false}) async {
    if (isLoadingVehicles.value) {
      AppLogger.warning(
        'HomeController → fetchVehicles: skipped (already loading)',
      );
      return;
    }
    if (!hasMore.value && !reset) {
      AppLogger.warning(
        'HomeController → fetchVehicles: skipped (no more pages)',
      );
      return;
    }

    isLoadingVehicles.value = true;
    errorMessage.value = '';

    if (reset) {
      currentPage.value = 0;
      vehicles.clear();
      hasMore.value = true;
      AppLogger.info('HomeController → fetchVehicles: reset, page 0');
    }

    final String? filterKey = selectedCategoryIndex.value < categories.length
        ? categories[selectedCategoryIndex.value].filterKey
        : null;

    AppLogger.info(
      'HomeController → fetchVehicles: filter=$filterKey, '
      'page=${currentPage.value}, limit=$pageSize, '
      'offset=${currentPage.value * pageSize}',
    );

    final result = await _getVehiclesUseCase(
      filter: filterKey == 'all' ? null : filterKey,
      limit: pageSize,
      offset: currentPage.value * pageSize,
    );

    if (result.isSuccess && result.data != null) {
      final response = result.data!;
      vehicles.addAll(response.vehicles);
      totalVehicles.value = response.total;
      hasMore.value = vehicles.length < totalVehicles.value;
      currentPage.value++;
      AppLogger.info(
        'HomeController → fetchVehicles: success — '
        'loaded ${response.vehicles.length} vehicles, '
        'total=${response.total}, hasMore=${hasMore.value}',
      );
    } else {
      final err = result.error ?? 'Failed to load vehicles';
      errorMessage.value = err;
      AppLogger.error('HomeController → fetchVehicles: FAILED — $err');
    }

    isLoadingVehicles.value = false;
  }

  // ── Filter by Category ───────────────────────────────────────
  void filterByCategory(int index) {
    if (selectedCategoryIndex.value == index) {
      AppLogger.info(
        'HomeController → filterByCategory: skipped (same index=$index)',
      );
      return;
    }
    AppLogger.info('HomeController → filterByCategory: index=$index');
    selectedCategoryIndex.value = index;
    fetchVehicles(reset: true);
  }

  // ── Load More (Pagination) ───────────────────────────────────
  Future<void> loadMore() async {
    AppLogger.info(
      'HomeController → loadMore: hasMore=${hasMore.value}, '
      'isLoading=${isLoadingVehicles.value}',
    );
    if (hasMore.value && !isLoadingVehicles.value) {
      await fetchVehicles();
    }
  }

  final RxString userImage = ''.obs;
  void loadUserFromHive() {
    final hive = HiveService();

    final userDetails = hive.getUserDetails();
    AppLogger.info("🔥 FULL HIVE DATA: $userDetails");

    final name = (userDetails['name'] ?? '').toString().trim();

    userName.value = name.isEmpty ? 'Guest' : name;
    userImage.value = userDetails['profileImage'] ?? '';

    AppLogger.info("👤 User loaded from Hive: ${userName.value}");
  }

  final FocusNode searchFocusNode = FocusNode();
  final RxBool isSearchFocused = false.obs;

  // Your hint texts — customise this list
  final List<String> searchHints = [
    'search'.tr,
    'Search by vehicle name...',
    'Search by category...',
    'Search by brand...',
  ];
  void focusSearch() {
    isSearchFocused.value = true;
    searchFocusNode.requestFocus();
  }

  // ── Refresh Data ─────────────────────────────────────────────
  Future<void> refreshData() async {
    AppLogger.info('HomeController → refreshData');
    await fetchCategories();
    await fetchVehicles(reset: true);
  }

  // ── Get Filtered Vehicles (for backward compatibility) ───────
  // List<VehicleEntity> get filteredVehicles => vehicles.toList();
  List<VehicleEntity> get filteredVehicles {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) return vehicles;

    return vehicles.where((v) {
      final name = v.nameKey.toLowerCase();
      final brand = (v.make ?? '').toLowerCase();
      final category = v.categoryKey.toLowerCase();
      final categoryName = (v.categoryName ?? '').toLowerCase();

      // 🔥 split search words (e.g. "maruti swift")
      final words = query.split(' ');

      return words.every(
        (word) =>
            name.contains(word) ||
            brand.contains(word) ||
            category.contains(word) ||
            categoryName.contains(word),
      );
    }).toList();
  }

  // ── Navigation Methods ────────────────────────────────────────
  void onSeeAll() {
    AppLogger.info('HomeController → onSeeAll');
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchFocusNode.unfocus();
    isSearchFocused.value = false;
  }

  // UPDATED: Use unified vehicle detail screen for ALL vehicles
  void onVehicleDetails(VehicleEntity vehicle) {
    AppLogger.info(
      'HomeController → onVehicleDetails: '
      'vehicle=${vehicle.nameKey}, category=${vehicle.categoryKey}, '
      'using unified detail screen',
    );

    // Use unified screen for ALL vehicle types
    Get.toNamed(
      Routes.unifiedVehicleDetail,
      arguments: {
        'id': vehicle.id, // Pass only ID, controller will fetch details
        'vehicle': vehicle, // Pass full entity as fallback
        'categoryKey': vehicle.categoryKey,
        'name': vehicle.nameKey,
        'rating': vehicle.rating,
        'capacity': vehicle.capacity,
        'fare': vehicle.fare,
        'eta': vehicle.eta,
        'imagePath': vehicle.imagePath,
        'distance': '3.2',
        'tripsCompleted': vehicle.driverTrips.toString(),
        'categoryKey': vehicle.categoryKey,
        'driverName': vehicle.driverName,
        'driverPhoto': vehicle.driverPhoto,
        'isOnline': vehicle.isOnline,
        'registrationNo': vehicle.registrationNo,
      },
    );
  }

  // Alternative: Simplified version - just pass ID
  void onVehicleDetailsSimple(VehicleEntity vehicle) {
    AppLogger.info(
      'HomeController → onVehicleDetailsSimple: '
      'vehicle=${vehicle.nameKey}, id=${vehicle.id}',
    );

    // Just pass the ID, controller will fetch all details
    Get.toNamed(Routes.unifiedVehicleDetail, arguments: {'id': vehicle.id});
  }

  /*
  void onBookNow(VehicleEntity vehicle) {
    String routeName;

    switch (vehicle.categoryKey) {
      case 'car':
        routeName = Routes.carBooking;
        break;
      case 'lorry':
        routeName = Routes.lorryBooking;
        break;
      case 'tataace':
        routeName = Routes.tataAceBooking;
        break;
      case 'bus':
        routeName = Routes.busBooking;
        break;
      case 'jcb':
        routeName = Routes.jcbBooking;
        break;
      case 'tractor':
        routeName = Routes.tractorBooking;
        break;
      case 'agri':
        routeName = Routes.agriBooking;
        break;
      default:
        routeName = Routes.bookingDetails;
    }

    AppLogger.info(
      'HomeController → onBookNow: '
      'vehicle=${vehicle.nameKey}, category=${vehicle.categoryKey}, route=$routeName',
    );

    Get.toNamed(
      routeName,
      arguments: {
        'id': vehicle.id,
        'name': vehicle.nameKey,
        'rating': vehicle.rating,
        'capacity': vehicle.capacity,
        'fare': vehicle.fare,
        'eta': vehicle.eta,
        'imagePath': vehicle.imagePath,
        'distance': '3.2',
        'tripsCompleted': vehicle.driverTrips.toString(),
        'categoryKey': vehicle.categoryKey,
        'driverName': vehicle.driverName,
        'driverPhoto': vehicle.driverPhoto,
      },
    );
  }
*/
  void onBookNow(VehicleEntity vehicle) {
    AppLogger.info(
      'HomeController → onBookNow: '
      'vehicle=${vehicle.nameKey}, category=${vehicle.categoryKey}',
    );

    // Parse fare value
    double farePerKm = 0.0;
    if (vehicle.fare.isNotEmpty) {
      farePerKm =
          double.tryParse(
            vehicle.fare.replaceAll('₹', '').replaceAll('/km', '').trim(),
          ) ??
          0.0;
    }

    Get.toNamed(
      Routes.unifiedBooking,
      arguments: {
        // Basic vehicle info
        'id': vehicle.id,
        'vehicleId': vehicle.id,
        'vehicleName': vehicle.nameKey,
        'name': vehicle.nameKey,
        'imagePath': vehicle.imagePath,
        'vehicleNumber': vehicle.registrationNo ?? '',
        'driverName': vehicle.driverName,
        'driverRating': double.tryParse(vehicle.rating) ?? 4.5,
        'vehicleType': vehicle.categoryKey,
        'categoryKey': vehicle.categoryKey,

        // Pricing
        'basePrice': vehicle.basePrice ?? 0.0,
        'fare': vehicle.fare,
        'farePerKm': farePerKm,
        'extraKmCharge': vehicle.extraKmCharge ?? 0.0,
        'extraHourCharge': vehicle.extraHourCharge ?? 0.0,
        'driverBata': vehicle.driverBata ?? 0.0,
        'operatorBata': vehicle.operatorBata ?? 0.0,
        'loadingCharge': vehicle.loadingCharge ?? 0.0,
        'unloadingCharge': vehicle.unloadingCharge ?? 0.0,

        // Vehicle specific fields
        'seatingCapacity': vehicle.capacity,
        'busCategory': vehicle.extraData?['bus_category'],
        'loadCapacity': vehicle.capacity,
        'bodyType': vehicle.extraData?['body_type'],
        'bucketType': vehicle.extraData?['bucket_type'],
        'fuelType': vehicle.fuelType,
        'horsePower': vehicle.extraData?['hp'],
        'attachment': vehicle.extraData?['attachment'],
        'equipmentType': vehicle.extraData?['equipment_type'],
        'capacity': vehicle.capacity,
        //'distance': vehicle.d ?? 10.0,
      },
    );
  }

  // ── Helper Methods for UI Compatibility ───────────────────────
  // FavoriteVehicle toFavorite(VehicleEntity v) {
  //   return FavoriteVehicle(
  //     id: v.id.toString(),
  //     nameKey: v.nameKey,
  //     rating: v.rating,
  //     capacity: v.capacity,
  //     fare: v.fare,
  //     eta: v.eta,
  //     categoryKey: v.categoryKey,
  //     availabilityStatus: v.isOnline ? 'available' : 'unavailable',
  //     imagePath: v.imagePath,
  //   );
  // }
  FavoriteEntity toFavorite(VehicleEntity v) {
    return FavoriteEntity(
      id: v.id,
      nameKey: v.nameKey,
      rating: v.rating,
      capacity: v.capacity,
      fare: v.fare,
      eta: v.eta,
      categoryKey: v.categoryKey,
      availabilityStatus: v.isOnline ? 'available' : 'unavailable',
      imagePath: v.imagePath,
    );
  }

  void onVehicleCardTap(VehicleEntity vehicle) {
    final currentCat = selectedCategoryIndex.value < categories.length
        ? categories[selectedCategoryIndex.value]
        : null;

    AppLogger.info(
      'HomeController → onVehicleCardTap: '
      'vehicle=${vehicle.nameKey}, currentFilter=${currentCat?.filterKey}',
    );

    if (currentCat?.filterKey == 'all') {
      final catIndex = categories.indexWhere(
        (c) => c.filterKey == vehicle.categoryKey,
      );
      if (catIndex != -1) {
        AppLogger.info(
          'HomeController → onVehicleCardTap: switching to category index=$catIndex',
        );
        filterByCategory(catIndex);
      }
    } else {
      onVehicleDetails(vehicle);
    }
  }

  void selectCategory(int index) => filterByCategory(index);
  void onNavTapped(int index) {
    AppLogger.info('HomeController → onNavTapped: index=$index');
    currentNavIndex.value = index;
  }

  @override
  void onClose() {
    AppLogger.info('HomeController → onClose');
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
