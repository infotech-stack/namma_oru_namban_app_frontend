// lib/features/vehicle_details/tata_ace/controllers/tata_ace_vehicle_detail_controller.dart

import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/constants/app_images.dart';

class TataAceVehicleDetailController extends GetxController {
  // ─── ALL VARIABLES AS Rx - with .value ─────────────────────

  // Vehicle Details
  final name = 'Tata Ace Gold'.obs;
  final rating = '4.8'.obs;
  final vehicleNumber = 'TN 22 AB 4589'.obs;
  final vehicleModel = 'Tata Ace Gold'.obs;
  final vehicleType = 'Mini Truck'.obs;
  final fuelType = 'Diesel'.obs;
  final bodyType = 'OPEN BODY'.obs;
  final payloadCapacity = '750 kg'.obs;
  final grossWeight = '1615 kg'.obs;
  final fare = '18'.obs;
  final fareUnit = '/km'.obs;
  final eta = '15'.obs;
  final distance = '3.2'.obs;
  final tripsCompleted = '420'.obs;
  final imagePath = Rx<String?>(null);

  // Pricing
  final pricePerKm = '₹18/km'.obs;
  final pricePerTrip = '₹80/trip'.obs;
  final loadingBase = '₹500'.obs;
  final driverBata = '₹500/day'.obs;

  // Usage Types
  final usageTypes = <String>[].obs;

  // Owner Info
  final ownerName = 'Senthil'.obs;
  final ownerRating = '4.9'.obs;
  final ownerTrips = '580'.obs;

  // Description
  final description =
      '''
Tata Ace - India's most popular mini truck. Perfect for small businesses, local deliveries, and last-mile transportation. Fuel-efficient, easy to maneuver in city traffic, and reliable for daily use. Well-maintained vehicle with experienced driver.
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
      name.value = args['name'] ?? 'Tata Ace Gold';
      rating.value = args['rating'] ?? '4.8';
      vehicleNumber.value = args['vehicleNumber'] ?? 'TN 22 AB 4589';
      vehicleModel.value = args['vehicleModel'] ?? 'Tata Ace Gold';
      fuelType.value = args['fuelType'] ?? 'Diesel';
      bodyType.value = args['bodyType'] ?? 'OPEN BODY';
      payloadCapacity.value = args['payloadCapacity'] ?? '750 kg';
      grossWeight.value = args['grossWeight'] ?? '1615 kg';
      fare.value = args['fare'] ?? '18';
      eta.value = args['eta'] ?? '15';
      distance.value = args['distance'] ?? '3.2';
      tripsCompleted.value = args['tripsCompleted'] ?? '420';
      imagePath.value = args['imagePath'];

      pricePerKm.value = args['pricePerKm'] ?? '₹18/km';
      pricePerTrip.value = args['pricePerTrip'] ?? '₹80/trip';
      loadingBase.value = args['loadingBase'] ?? '₹500';
      driverBata.value = args['driverBata'] ?? '₹500/day';

      ownerName.value = args['ownerName'] ?? 'Senthil';
      ownerRating.value = args['ownerRating'] ?? '4.9';
      ownerTrips.value = args['ownerTrips'] ?? '580';

      if (args['usageTypes'] != null) {
        usageTypes.value = List<String>.from(args['usageTypes']);
      } else {
        usageTypes.value = ['Local', 'Intercity', 'Porter'];
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
      {'label': 'payload_capacity', 'value': payloadCapacity.value},
      {'label': 'gross_weight', 'value': grossWeight.value},
      {'label': 'price_per_km', 'value': pricePerKm.value},
      {'label': 'price_per_trip', 'value': pricePerTrip.value},
      {'label': 'loading_base', 'value': loadingBase.value},
      {'label': 'driver_bata', 'value': driverBata.value},
    ]);
  }

  void loadReviews() {
    reviews.assignAll([
      {
        'name': 'Senthil',
        'avatar': 'S',
        'rating': 5,
        'comment':
            'Perfect for small loads! Ace is reliable and driver was great.',
        'date': '2 days ago',
      },
      {
        'name': 'Mani',
        'avatar': 'M',
        'rating': 4,
        'comment': 'Good service. Vehicle was clean and on time.',
        'date': '1 week ago',
      },
      {
        'name': 'Kannan',
        'avatar': 'K',
        'rating': 5,
        'comment': 'Best mini truck for city deliveries. Highly recommended!',
        'date': '2 weeks ago',
      },
    ]);
  }

  void loadImages() {
    images.assignAll([
      imagePath.value ?? '',
      AppAssetsConstants.tataAce,
      AppAssetsConstants.tataAce2,
    ]);
  }

  List<String?> get vehicleImages => [
    imagePath.value,
    AppAssetsConstants.tataAce,
    AppAssetsConstants.tataAce2,
    null,
  ];

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
      Routes.tataAceBooking,
      arguments: {
        'vehicleName': name.value,
        'vehicleNumber': vehicleNumber.value,
        'vehicleModel': vehicleModel.value,
        'fuelType': fuelType.value,
        'bodyType': bodyType.value,
        'payloadCapacity': payloadCapacity.value,
        'pricePerKm': pricePerKm.value,
        'pricePerTrip': pricePerTrip.value,
        'loadingBase': loadingBase.value,
        'driverBata': driverBata.value,
        'fare': fare.value,
        'imagePath': imagePath.value,
      },
    );
  }
}
