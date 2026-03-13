// lib/features/vehicle_details/lorry/controllers/lorry_vehicle_detail_controller.dart

import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/constants/app_images.dart';

class LorryVehicleDetailController extends GetxController {
  // ─── ALL VARIABLES AS Rx - with .value ─────────────────────

  // Vehicle Details
  final name = 'Tata 407'.obs;
  final rating = '4.8'.obs;
  final vehicleNumber = 'TN 22 AB 4589'.obs;
  final vehicleModel = 'Tata 407'.obs;
  final vehicleType = 'Lorry'.obs;
  final fuelType = 'Diesel'.obs;
  final bodyType = 'OPEN BODY'.obs;
  final loadCapacity = '5 Tons'.obs;
  final fare = '35'.obs;
  final fareUnit = '/km'.obs;
  final eta = '25'.obs;
  final distance = '3.2'.obs;
  final tripsCompleted = '350'.obs;
  final imagePath = Rx<String?>(null);

  // Pricing
  final basePrice = 3500.0.obs;
  final loadingCharge = '₹500'.obs;
  final unloadingCharge = '₹500'.obs;
  final driverBata = '₹300'.obs;
  final pricingModel = 'Per Load'.obs;

  // Owner Info
  final ownerName = 'Kumar'.obs;
  final ownerRating = '4.9'.obs;
  final ownerTrips = '450'.obs;

  // Load Types (multi-select from registration)
  final loadTypes = <String>[].obs;

  // Description
  final description =
      '''
Reliable Tata 407 lorry for all your goods transport needs. Perfect for moving construction materials, furniture, and general goods. Well-maintained vehicle with experienced driver. Suitable for both city and highway transport.
'''
          .obs;

  // Collections with Rx
  final specs = <Map<String, String>>[].obs;
  final reviews = <Map<String, dynamic>>[].obs;
  final images = <String>[].obs;

  // UI States with Rx
  final isFavourite = false.obs;
  final isReadMore = false.obs;
  final currentImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null) {
      name.value = args['name'] ?? 'Tata 407';
      rating.value = args['rating'] ?? '4.8';
      vehicleNumber.value = args['vehicleNumber'] ?? 'TN 22 AB 4589';
      vehicleModel.value = args['vehicleModel'] ?? 'Tata 407';
      fuelType.value = args['fuelType'] ?? 'Diesel';
      bodyType.value = args['bodyType'] ?? 'OPEN BODY';
      loadCapacity.value = args['loadCapacity'] ?? '5 Tons';
      fare.value = args['fare'] ?? '35';
      fareUnit.value = args['fareUnit'] ?? '/km';
      eta.value = args['eta'] ?? '25';
      distance.value = args['distance'] ?? '3.2';
      tripsCompleted.value = args['tripsCompleted'] ?? '350';
      imagePath.value = args['imagePath'];

      basePrice.value = args['basePrice'] ?? 3500.0;
      loadingCharge.value = args['loadingCharge'] ?? '₹500';
      unloadingCharge.value = args['unloadingCharge'] ?? '₹500';
      driverBata.value = args['driverBata'] ?? '₹300';
      pricingModel.value = args['pricingModel'] ?? 'Per Load';

      ownerName.value = args['ownerName'] ?? 'Kumar';
      ownerRating.value = args['ownerRating'] ?? '4.9';
      ownerTrips.value = args['ownerTrips'] ?? '450';

      // Load load types from args
      if (args['loadTypes'] != null) {
        loadTypes.value = List<String>.from(args['loadTypes']);
      } else {
        // Default load types
        loadTypes.value = [
          'lorry_load_m_sand',
          'lorry_load_20mm_jelly',
          'lorry_load_cement',
        ];
      }
    }

    loadSpecs();
    loadReviews();
    loadImages();
  }

  void loadSpecs() {
    specs.assignAll([
      {'label': 'vehicle_model', 'value': vehicleModel.value},
      {'label': 'fuel_type', 'value': fuelType.value},
      {'label': 'body_type', 'value': bodyType.value},
      {'label': 'load_capacity', 'value': loadCapacity.value},
      {'label': 'loading_charge', 'value': loadingCharge.value},
      {'label': 'unloading_charge', 'value': unloadingCharge.value},
      {'label': 'driver_bata', 'value': driverBata.value},
      {'label': 'pricing_model', 'value': pricingModel.value},
    ]);
  }

  void loadReviews() {
    reviews.assignAll([
      {
        'name': 'Kumar',
        'avatar': 'K',
        'rating': 5,
        'comment':
            'Excellent service! Lorry was clean and driver was professional.',
        'date': '2 days ago',
      },
      {
        'name': 'Rajan',
        'avatar': 'R',
        'rating': 4,
        'comment': 'Good experience. On time delivery.',
        'date': '1 week ago',
      },
      {
        'name': 'Selvam',
        'avatar': 'S',
        'rating': 5,
        'comment': 'Best lorry service in town!',
        'date': '2 weeks ago',
      },
    ]);
  }

  void loadImages() {
    images.assignAll([
      imagePath.value ?? '',
      AppAssetsConstants.lorry,
      AppAssetsConstants.lorry2,
    ]);
  }

  List<String?> get vehicleImages => [
    imagePath.value,
    AppAssetsConstants.lorry,
    AppAssetsConstants.lorry2,
    null,
  ];

  // Getters for screen
  String get fare_km => '${fare.value}${fareUnit.value}';
  String get rating_value => rating.value;
  String get capacity_value => loadCapacity.value;
  String get eta_value => eta.value;
  String get distance_value => distance.value;
  String get trips_value => tripsCompleted.value;

  void toggleFavourite() {
    isFavourite.value = !isFavourite.value;
  }

  void toggleReadMore() {
    isReadMore.value = !isReadMore.value;
  }

  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }

  void onBookNow() {
    Get.toNamed(
      Routes.lorryBooking,
      arguments: {
        'vehicleName': name.value,
        'vehicleNumber': vehicleNumber.value,
        'vehicleModel': vehicleModel.value,
        'basePrice': basePrice.value,
        'loadingCharge': loadingCharge.value,
        'unloadingCharge': unloadingCharge.value,
        'driverBata': driverBata.value,
        'fare': fare.value,
        'fareUnit': fareUnit.value,
        'imagePath': imagePath.value,
        'loadCapacity': loadCapacity.value,
        'bodyType': bodyType.value,
      },
    );
  }
}
