import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';

class VehicleCategory {
  final String labelKey;
  final IconData icon;
  final String filterKey;

  VehicleCategory({
    required this.labelKey,
    required this.icon,
    required this.filterKey,
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
    ),
    VehicleCategory(
      labelKey: 'jcb',
      icon: Icons.construction_rounded,
      filterKey: 'jcb',
    ),
    VehicleCategory(
      labelKey: 'lorry',
      icon: Icons.local_shipping_rounded,
      filterKey: 'lorry',
    ),
    VehicleCategory(
      labelKey: 'truck',
      icon: Icons.airport_shuttle_rounded,
      filterKey: 'truck',
    ),
  ];

  final _allVehicles = <VehicleModel>[
    VehicleModel(
      nameKey: 'Container Truck',
      rating: '4.5',
      capacity: '10',
      fare: '₹25/km',
      eta: '18',
      categoryKey: 'truck',
    ),
    VehicleModel(
      nameKey: 'Container Truck',
      rating: '4.2',
      capacity: '8',
      fare: '₹20/km',
      eta: '22',
      categoryKey: 'truck',
    ),
    VehicleModel(
      nameKey: 'Sedan Car',
      rating: '4.7',
      capacity: '4',
      fare: '₹10/km',
      eta: '10',
      categoryKey: 'car',
    ),
    VehicleModel(
      nameKey: 'Sedan Car',
      rating: '4.3',
      capacity: '4',
      fare: '₹12/km',
      eta: '12',
      categoryKey: 'car',
    ),
    VehicleModel(
      nameKey: 'JCB Machine',
      rating: '4.0',
      capacity: '5',
      fare: '₹50/km',
      eta: '30',
      categoryKey: 'jcb',
    ),
    VehicleModel(
      nameKey: 'JCB Machine',
      rating: '4.1',
      capacity: '6',
      fare: '₹55/km',
      eta: '35',
      categoryKey: 'jcb',
    ),
    VehicleModel(
      nameKey: 'Mini Lorry',
      rating: '4.4',
      capacity: '15',
      fare: '₹30/km',
      eta: '25',
      categoryKey: 'lorry',
    ),
    VehicleModel(
      nameKey: 'Mini Lorry',
      rating: '4.6',
      capacity: '20',
      fare: '₹35/km',
      eta: '28',
      categoryKey: 'lorry',
    ),
  ];

  // Simple computed getter — no extra obs list needed
  List<VehicleModel> get filteredVehicles {
    final key = categories[selectedCategoryIndex.value].filterKey;
    if (key == 'all') return _allVehicles;
    return _allVehicles.where((v) => v.categoryKey == key).toList();
  }

  void selectCategory(int index) => selectedCategoryIndex.value = index;
  void onNavTapped(int index) => currentNavIndex.value = index;
  void onSeeAll() {}
  void onBookNow(VehicleModel vehicle) {
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
