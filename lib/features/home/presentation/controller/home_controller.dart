// lib/features/home/presentation/controller/home_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:userapp/utils/constants/app_images.dart';

class VehicleCategory {
  final String labelKey;
  final IconData icon;
  final String filterKey;
  String? imagePath;

  VehicleCategory({
    required this.labelKey,
    required this.icon,
    required this.filterKey,
    this.imagePath,
  });
}

class VehicleModel {
  final String nameKey;
  final String rating;
  final String capacity;
  final String fare;
  final String eta;
  final String categoryKey;
  String? imagePath;

  VehicleModel({
    required this.nameKey,
    required this.rating,
    required this.capacity,
    required this.fare,
    required this.eta,
    required this.categoryKey,
    this.imagePath,
  });
}

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is int && currentNavIndex.value == 0) {
      currentNavIndex.value = args;
    }
  }

  final searchController = TextEditingController();
  final userName = 'John Smith'.obs;
  final currentNavIndex = 0.obs;
  final selectedCategoryIndex = 0.obs;

  final categories = <VehicleCategory>[
    VehicleCategory(
      labelKey: 'all',
      icon: Icons.grid_view_rounded,
      filterKey: 'all',
    ),
    VehicleCategory(
      labelKey: 'car',
      icon: Icons.directions_car_rounded,
      filterKey: 'car',
      imagePath: AppAssetsConstants.car3,
    ),
    VehicleCategory(
      labelKey: 'jcb',
      icon: Icons.construction_rounded,
      filterKey: 'jcb',
      imagePath: AppAssetsConstants.jcb2,
    ),
    VehicleCategory(
      labelKey: 'lorry',
      icon: Icons.local_shipping_rounded,
      filterKey: 'lorry',
      imagePath: AppAssetsConstants.lorry,
    ),
    VehicleCategory(
      labelKey: 'tataace',
      icon: Icons.airport_shuttle_rounded,
      filterKey: 'tataace',
      imagePath: AppAssetsConstants.tataAce,
    ),
    VehicleCategory(
      labelKey: 'bus',
      icon: Icons.directions_bus_filled_rounded,
      filterKey: 'bus',
      imagePath: AppAssetsConstants.bus,
    ),
    VehicleCategory(
      labelKey: 'tractor',
      icon: Icons.agriculture_outlined,
      filterKey: 'tractor',
      imagePath: AppAssetsConstants.tractor,
    ),
    VehicleCategory(
      labelKey: 'agri',
      icon: Icons.agriculture,
      filterKey: 'agri',
      imagePath: AppAssetsConstants.agri1,
    ),
  ];

  final _allVehicles = <VehicleModel>[
    // 🚌 Bus
    VehicleModel(
      nameKey: 'Mini Bus',
      rating: '4.5',
      capacity: '25 Passengers',
      fare: '40',
      eta: '20',
      categoryKey: 'bus',
      imagePath: AppAssetsConstants.minibus,
    ),
    // 🚗 Car
    VehicleModel(
      nameKey: 'Sedan Car',
      rating: '4.7',
      capacity: '4 Passengers',
      fare: '10',
      eta: '10',
      categoryKey: 'car',
      imagePath: AppAssetsConstants.car2,
    ),
    // 🚐 Tata Ace
    VehicleModel(
      nameKey: 'TATA ACE',
      rating: '4.6',
      capacity: '1.5 Ton',
      fare: '18',
      eta: '15',
      categoryKey: 'tataace',
      imagePath: AppAssetsConstants.tataAce3,
    ),
    // 🚚 Lorry
    VehicleModel(
      nameKey: 'Lorry 6 Ton',
      rating: '4.6',
      capacity: '6 Ton',
      fare: '35',
      eta: '28',
      categoryKey: 'lorry',
      imagePath: AppAssetsConstants.lorry,
    ),
    // 🏗 JCB
    VehicleModel(
      nameKey: 'JCB Machine',
      rating: '4.0',
      capacity: '5 Ton',
      fare: '50',
      eta: '30',
      categoryKey: 'jcb',
      imagePath: AppAssetsConstants.jcb,
    ),
    // 🚜 Tractor
    VehicleModel(
      nameKey: 'Farm Tractor',
      rating: '4.3',
      capacity: '2 Ton',
      fare: '22',
      eta: '17',
      categoryKey: 'tractor',
      imagePath: AppAssetsConstants.tractor1,
    ),
    // 🚗 Car
    VehicleModel(
      nameKey: 'SUV Car',
      rating: '4.3',
      capacity: '7 Passengers',
      fare: '12',
      eta: '12',
      categoryKey: 'car',
      imagePath: AppAssetsConstants.car,
    ),
    // 🌾 Agriculture
    VehicleModel(
      nameKey: 'Harvest Machine',
      rating: '4.4',
      capacity: '3 Ton',
      fare: '60',
      eta: '45',
      categoryKey: 'agri',
      imagePath: AppAssetsConstants.agri3,
    ),
    // 🚐 Tata Ace
    VehicleModel(
      nameKey: 'TATA ACE XL',
      rating: '4.6',
      capacity: '2 Ton',
      fare: '20',
      eta: '15',
      categoryKey: 'tataace',
      imagePath: AppAssetsConstants.tataAce2,
    ),
    // 🚌 Bus
    VehicleModel(
      nameKey: 'AC Bus',
      rating: '4.8',
      capacity: '40 Passengers',
      fare: '55',
      eta: '18',
      categoryKey: 'bus',
      imagePath: AppAssetsConstants.bus2,
    ),
    // 🌾 Agriculture
    VehicleModel(
      nameKey: 'Tractor',
      rating: '4.4',
      capacity: '3 ACR',
      fare: '60',
      eta: '45',
      categoryKey: 'agri',
      imagePath: AppAssetsConstants.agri2,
    ),
    // 🚜 Tractor
    VehicleModel(
      nameKey: 'Power Tractor',
      rating: '4.3',
      capacity: '3 Ton',
      fare: '25',
      eta: '17',
      categoryKey: 'tractor',
      imagePath: AppAssetsConstants.tractor2,
    ),
    // 🚚 Lorry
    VehicleModel(
      nameKey: 'Lorry 4 Ton',
      rating: '4.4',
      capacity: '4 Ton',
      fare: '30',
      eta: '25',
      categoryKey: 'lorry',
      imagePath: AppAssetsConstants.lorry2,
    ),
    // 🏗 JCB
    VehicleModel(
      nameKey: 'JCB 3DX',
      rating: '4.1',
      capacity: '6 Ton',
      fare: '55',
      eta: '35',
      categoryKey: 'jcb',
      imagePath: AppAssetsConstants.jcb2,
    ),
    // 🌾 Agriculture
    VehicleModel(
      nameKey: 'Harvester',
      rating: '4.4',
      capacity: '3 Ton',
      fare: '60',
      eta: '45',
      categoryKey: 'agri',
      imagePath: AppAssetsConstants.agri1,
    ),
  ];

  List<VehicleModel> get filteredVehicles {
    final key = categories[selectedCategoryIndex.value].filterKey;
    if (key == 'all') return _allVehicles;
    return _allVehicles.where((v) => v.categoryKey == key).toList();
  }

  void selectCategory(int index) => selectedCategoryIndex.value = index;
  void onNavTapped(int index) => currentNavIndex.value = index;
  void onSeeAll() {}

  // ── FIXED: Proper navigation based on vehicle type ───────────────────
  void onvehicleDetails(VehicleModel vehicle) {
    String routeName;

    // Map category to appropriate detail screen
    switch (vehicle.categoryKey) {
      case 'car':
        routeName = Routes.carVehicleDetail;
        break;
      case 'lorry':
        routeName = Routes.lorryVehicleDetail;
        break;
      case 'tataace':
        routeName = Routes.tataAceVehicleDetail;
        break;
      case 'bus':
        routeName = Routes.busVehicleDetail;
        break;
      case 'jcb':
        routeName = Routes.jcbVehicleDetail;
        break;
      case 'tractor':
        routeName = Routes.tractorVehicleDetail;
        break;
      case 'agri':
        routeName = Routes.agriVehicleDetail;
        break;
      default:
        routeName = Routes.vehDetails; // fallback to generic
    }

    Get.toNamed(
      routeName,
      arguments: {
        'name': vehicle.nameKey,
        'rating': vehicle.rating,
        'capacity': vehicle.capacity,
        'fare': vehicle.fare,
        'eta': vehicle.eta,
        'imagePath': vehicle.imagePath,
        'distance': '3.2',
        'tripsCompleted': '120',
        // Add category for additional vehicle-specific data
        'categoryKey': vehicle.categoryKey,
      },
    );
  }

  // ── FIXED: Proper booking navigation based on vehicle type ───────────
  void onBookNow(VehicleModel vehicle) {
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
        routeName = Routes.bookingDetails; // fallback
    }

    Get.toNamed(
      routeName,
      arguments: {
        'name': vehicle.nameKey,
        'rating': vehicle.rating,
        'capacity': vehicle.capacity,
        'fare': vehicle.fare,
        'eta': vehicle.eta,
        'imagePath': vehicle.imagePath,
        'distance': '3.2',
        'tripsCompleted': '120',
        'categoryKey': vehicle.categoryKey,
      },
    );
  }

  FavoriteVehicle toFavorite(VehicleModel v) {
    return FavoriteVehicle(
      id: '${v.categoryKey}_${v.nameKey}',
      nameKey: v.nameKey,
      rating: v.rating,
      capacity: v.capacity,
      fare: v.fare,
      eta: v.eta,
      categoryKey: v.categoryKey,
      availabilityStatus: 'available',
      imagePath: v.imagePath,
    );
  }

  void onVehicleCardTap(VehicleModel vehicle) {
    final currentCat = categories[selectedCategoryIndex.value];

    if (currentCat.filterKey == 'all') {
      // ── "All" tab — tap → switch to that vehicle's category ──
      final catIndex = categories.indexWhere(
        (c) => c.filterKey == vehicle.categoryKey,
      );
      if (catIndex != -1) {
        selectedCategoryIndex.value = catIndex;
      }
    } else {
      // ── Specific category tab — tap → vehicle details ─────────
      onvehicleDetails(vehicle);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
