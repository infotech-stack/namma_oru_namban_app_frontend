// lib/features/vehicle_details/bus/controllers/bus_vehicle_detail_controller.dart

import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/constants/app_images.dart';

class BusVehicleDetailController extends GetxController {
  // ─── ALL VARIABLES AS Rx - with .value ─────────────────────

  // Vehicle Details
  final name = 'Semi Sleeper Bus'.obs;
  final rating = '4.8'.obs;
  final vehicleNumber = 'TN 22 AB 4589'.obs;
  final busCategory = 'Semi Sleeper'.obs;
  final busType = 'Luxury Bus'.obs;
  final manufacturer = 'Ashok Leyland'.obs;
  final seatingCapacity = '38 Seats'.obs;
  final seatType = 'Pushback'.obs;
  final acAvailable = 'Yes'.obs;
  final chargingPoints = 'Yes'.obs;
  final entertainment = 'LED TV'.obs;
  final toilet = 'No'.obs;
  final fare = '45'.obs;
  final fareUnit = '/km'.obs;
  final eta = '25'.obs;
  final distance = '3.2'.obs;
  final tripsCompleted = '250'.obs;
  final imagePath = Rx<String?>(null);

  // Pricing
  final basePrice = 4500.0.obs;
  final pricePerKm = 45.0.obs;
  final minKm = 50.obs;
  final driverBata = 300.0.obs;

  // Owner Info
  final ownerName = 'Raj Travels'.obs;
  final ownerRating = '4.9'.obs;
  final ownerTrips = '450'.obs;

  // Amenities
  final amenities = <String>[].obs;

  // Description
  final description =
      '''
Experience comfortable travel with this Semi Sleeper Bus. Perfect for intercity travel, tours, and group outings. Features include pushback seats, AC, charging points, and entertainment system. Well-maintained bus with experienced driver.
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
      name.value = args['name'] ?? 'Semi Sleeper Bus';
      rating.value = args['rating'] ?? '4.8';
      vehicleNumber.value = args['vehicleNumber'] ?? 'TN 22 AB 4589';
      busCategory.value = args['busCategory'] ?? 'Semi Sleeper';
      manufacturer.value = args['manufacturer'] ?? 'Ashok Leyland';
      seatingCapacity.value = args['seatingCapacity'] ?? '38 Seats';
      seatType.value = args['seatType'] ?? 'Pushback';
      acAvailable.value = args['acAvailable'] ?? 'Yes';
      chargingPoints.value = args['chargingPoints'] ?? 'Yes';
      entertainment.value = args['entertainment'] ?? 'LED TV';
      toilet.value = args['toilet'] ?? 'No';
      fare.value = args['fare'] ?? '45';
      eta.value = args['eta'] ?? '25';
      distance.value = args['distance'] ?? '3.2';
      tripsCompleted.value = args['tripsCompleted'] ?? '250';
      imagePath.value = args['imagePath'];

      basePrice.value = args['basePrice'] ?? 4500.0;
      pricePerKm.value = args['pricePerKm'] ?? 45.0;
      minKm.value = args['minKm'] ?? 50;
      driverBata.value = args['driverBata'] ?? 300.0;

      ownerName.value = args['ownerName'] ?? 'Raj Travels';
      ownerRating.value = args['ownerRating'] ?? '4.9';
      ownerTrips.value = args['ownerTrips'] ?? '450';
    }

    loadAmenities();
    loadSpecs();
    loadReviews();
    loadImages();
  }

  void loadAmenities() {
    amenities.assignAll([
      'ac',
      'charging_points',
      'entertainment',
      'water_bottle',
      'first_aid',
      'tracking',
    ]);
  }

  void loadSpecs() {
    specs.assignAll([
      {'label': 'bus_category', 'value': busCategory.value},
      {'label': 'manufacturer', 'value': manufacturer.value},
      {'label': 'seating_capacity', 'value': seatingCapacity.value},
      {'label': 'seat_type', 'value': seatType.value},
      {'label': 'ac_available', 'value': acAvailable.value},
      {'label': 'charging_points', 'value': chargingPoints.value},
      {'label': 'entertainment', 'value': entertainment.value},
      {'label': 'toilet', 'value': toilet.value},
    ]);
  }

  void loadReviews() {
    reviews.assignAll([
      {
        'name': 'Rajesh Kumar',
        'avatar': 'RK',
        'rating': 5,
        'comment':
            'Very comfortable bus! On time and clean. Driver was professional.',
        'date': '3 days ago',
      },
      {
        'name': 'Priya R',
        'avatar': 'PR',
        'rating': 4,
        'comment': 'Good experience. AC was perfect and seats comfortable.',
        'date': '1 week ago',
      },
      {
        'name': 'Suresh M',
        'avatar': 'SM',
        'rating': 5,
        'comment': 'Best bus service for tours. Highly recommended!',
        'date': '2 weeks ago',
      },
    ]);
  }

  void loadImages() {
    images.assignAll([
      imagePath.value ?? '',
      AppAssetsConstants.bus,
      AppAssetsConstants.bus2,
    ]);
  }

  List<String?> get vehicleImages => [
    imagePath.value,
    AppAssetsConstants.bus,
    AppAssetsConstants.bus2,
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
      Routes.busBooking,
      arguments: {
        'vehicleName': name.value,
        'vehicleNumber': vehicleNumber.value,
        'busCategory': busCategory.value,
        'seatingCapacity': seatingCapacity.value,
        'basePrice': basePrice.value,
        'pricePerKm': pricePerKm.value,
        'minKm': minKm.value,
        'driverBata': driverBata.value,
        'fare': fare.value,
        'imagePath': imagePath.value,
        'acAvailable': acAvailable.value,
        'chargingPoints': chargingPoints.value,
        'entertainment': entertainment.value,
      },
    );
  }
}
