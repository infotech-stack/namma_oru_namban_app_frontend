import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
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
    // 🚗 Car
    VehicleModel(
      nameKey: 'Sedan Car',
      rating: '4.7',
      capacity: '4 ${'passengers'.tr}',
      fare: '₹10/km',
      eta: '10',
      categoryKey: 'car',
      imagePath: AppAssetsConstants.car2,
    ),

    // // 🚛 Truck
    // VehicleModel(
    //   nameKey: 'Container Truck',
    //   rating: '4.2',
    //   capacity: '8 Ton',
    //   fare: '₹20/km',
    //   eta: '22',
    //   categoryKey: 'truck',
    //   imagePath: AppAssetsConstants.lorry,
    // ),

    // 🚐 Tata Ace
    VehicleModel(
      nameKey: 'TATA ACE',
      rating: '4.6',
      capacity: '1.5 Ton',
      fare: '₹18/km',
      eta: '15',
      categoryKey: 'tataace',
      imagePath: AppAssetsConstants.tataAce3,
    ),

    // 🚌 Bus
    VehicleModel(
      nameKey: 'Mini Bus',
      rating: '4.5',
      capacity: '25 Passengers',
      fare: '₹40/km',
      eta: '20',
      categoryKey: 'bus',
      imagePath: AppAssetsConstants.minibus,
    ),

    // 🚚 Lorry
    VehicleModel(
      nameKey: 'Mini Lorry',
      rating: '4.6',
      capacity: '6 Ton',
      fare: '₹35/km',
      eta: '28',
      categoryKey: 'lorry',
      imagePath: AppAssetsConstants.lorry,
    ),

    // 🏗 JCB
    VehicleModel(
      nameKey: 'JCB Machine',
      rating: '4.0',
      capacity: '5 Ton',
      fare: '₹50/km',
      eta: '30',
      categoryKey: 'jcb',
      imagePath: AppAssetsConstants.jcb,
    ),

    // 🚜 Tractor
    VehicleModel(
      nameKey: 'Farm Tractor',
      rating: '4.3',
      capacity: '2 Ton',
      fare: '₹22/km',
      eta: '17',
      categoryKey: 'tractor',
      imagePath: AppAssetsConstants.tractor1,
    ),

    // 🚗 Car
    VehicleModel(
      nameKey: 'Sedan Car',
      rating: '4.3',
      capacity: '5 Passengers',
      fare: '₹12/km',
      eta: '12',
      categoryKey: 'car',
      imagePath: AppAssetsConstants.car,
    ),

    // // 🚛 Truck
    // VehicleModel(
    //   nameKey: 'Container Truck',
    //   rating: '4.5',
    //   capacity: '10 Ton',
    //   fare: '₹25/km',
    //   eta: '18',
    //   categoryKey: 'truck',
    //   imagePath: AppAssetsConstants.lorry,
    // ),
    VehicleModel(
      nameKey: 'Harvest Machine',
      rating: '4.4',
      capacity: '3 Ton',
      fare: '₹60/km',
      eta: '45',
      categoryKey: 'agri',
      imagePath: AppAssetsConstants.agri3,
    ),
    // 🚐 Tata Ace
    VehicleModel(
      nameKey: 'TATA ACE',
      rating: '4.6',
      capacity: '1.5 Ton',
      fare: '₹18/km',
      eta: '15',
      categoryKey: 'tataace',
      imagePath: AppAssetsConstants.tataAce2,
    ),

    // 🚌 Bus
    VehicleModel(
      nameKey: 'AC Bus',
      rating: '4.8',
      capacity: '40 Passengers',
      fare: '₹55/km',
      eta: '18',
      categoryKey: 'bus',
      imagePath: AppAssetsConstants.bus2,
    ),
    VehicleModel(
      nameKey: 'Harvest Machine',
      rating: '4.4',
      capacity: '3 ACR',
      fare: '₹60/km',
      eta: '45',
      categoryKey: 'agri',
      imagePath: AppAssetsConstants.agri2,
    ),
    VehicleModel(
      nameKey: 'Farm Tractor',
      rating: '4.3',
      capacity: '2 Ton',
      fare: '₹22/km',
      eta: '17',
      categoryKey: 'tractor',
      imagePath: AppAssetsConstants.tractor2,
    ),
    // 🚚 Lorry
    VehicleModel(
      nameKey: 'Mini Lorry',
      rating: '4.4',
      capacity: '4 Ton',
      fare: '₹30/km',
      eta: '25',
      categoryKey: 'lorry',
      imagePath: AppAssetsConstants.lorry2,
    ),

    // 🏗 JCB
    VehicleModel(
      nameKey: 'JCB Machine',
      rating: '4.1',
      capacity: '6 Ton',
      fare: '₹55/km',
      eta: '35',
      categoryKey: 'jcb',
      imagePath: AppAssetsConstants.jcb2,
    ),

    // 🌾 Agriculture
    VehicleModel(
      nameKey: 'Harvest Machine',
      rating: '4.4',
      capacity: '3 Ton',
      fare: '₹60/km',
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
  void onvehicleDetails(VehicleModel vehicle) {
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

  void onBookNow(VehicleModel vehicle) {
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
