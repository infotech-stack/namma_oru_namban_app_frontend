// lib/features/vehicle_details/car/controllers/car_vehicle_detail_controller.dart

import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/constants/app_images.dart';

class CarVehicleDetailController extends GetxController {
  // ─── ALL VARIABLES AS Rx - with .value ─────────────────────

  // Vehicle Details
  final name = 'Toyota Innova Crysta'.obs;
  final rating = '4.8'.obs;
  final vehicleNumber = 'TN 22 AB 4589'.obs;
  final seatingCapacity = '7+1 Seats'.obs;
  final seatType = 'Leather'.obs;
  final fuelType = 'Diesel'.obs;
  final transmission = 'Automatic'.obs;
  final acAvailable = 'Yes'.obs;
  final musicSystem = 'Yes'.obs;
  final fare = '40'.obs;
  final eta = '15'.obs;
  final distance = '3.2'.obs;
  final tripsCompleted = '120'.obs;
  final imagePath = Rx<String?>(null);

  // Manufacturer & Model
  final manufacturer = 'Toyota'.obs;
  final model = 'Innova Crysta'.obs;

  // Pricing
  final basePrice = 3500.0.obs;
  final extraKmCharge = 12.0.obs;
  final extraHourCharge = 150.0.obs;
  final driverBata = 150.0.obs;

  // Owner Info
  final ownerName = 'Sudarsan'.obs;
  final ownerRating = '4.9'.obs;
  final ownerTrips = '342'.obs;

  // Description
  final description =
      '''
Experience premium comfort with this Toyota Innova Crysta. Perfect for family trips and airport transfers. Features include leather seats, climate control, and ample legroom. Well-maintained and driven by experienced drivers. The car is equipped with modern amenities including touchscreen infotainment, reverse camera, and cruise control.
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
      // Read from Map - assign to .value
      name.value = args['name'] ?? 'Toyota Innova Crysta';
      rating.value = args['rating'] ?? '4.8';
      vehicleNumber.value = args['vehicleNumber'] ?? 'TN 22 AB 4589';
      seatingCapacity.value = args['seatingCapacity'] ?? '7+1 Seats';
      seatType.value = args['seatType'] ?? 'Leather';
      fuelType.value = args['fuelType'] ?? 'Diesel';
      transmission.value = args['transmission'] ?? 'Automatic';
      acAvailable.value = args['acAvailable'] ?? 'Yes';
      musicSystem.value = args['musicSystem'] ?? 'Yes';
      fare.value = args['fare'] ?? '40';
      eta.value = args['eta'] ?? '15';
      distance.value = args['distance'] ?? '3.2';
      tripsCompleted.value = args['tripsCompleted'] ?? '120';
      imagePath.value = args['imagePath'];

      manufacturer.value = args['manufacturer'] ?? 'Toyota';
      model.value = args['model'] ?? 'Innova Crysta';

      basePrice.value = args['basePrice'] ?? 3500.0;
      extraKmCharge.value = args['extraKmCharge'] ?? 12.0;
      extraHourCharge.value = args['extraHourCharge'] ?? 150.0;
      driverBata.value = args['driverBata'] ?? 150.0;

      ownerName.value = args['ownerName'] ?? 'Sudarsan';
      ownerRating.value = args['ownerRating'] ?? '4.9';
      ownerTrips.value = args['ownerTrips'] ?? '342';
    }

    loadSpecs();
    loadReviews();
    loadImages();
  }

  void loadSpecs() {
    specs.assignAll([
      {'label': 'manufacturer', 'value': manufacturer.value},
      {'label': 'model', 'value': model.value},
      {'label': 'seating', 'value': seatingCapacity.value},
      {'label': 'seat_type', 'value': seatType.value},
      {'label': 'fuel_type', 'value': fuelType.value},
      {'label': 'transmission', 'value': transmission.value},
      {'label': 'ac_available', 'value': acAvailable.value},
      {'label': 'music_system', 'value': musicSystem.value},
    ]);
  }

  void loadReviews() {
    reviews.assignAll([
      {
        'name': 'Ramesh Kumar',
        'avatar': 'RK',
        'rating': 5,
        'comment': 'Very clean car and punctual driver. Highly recommended!',
        'date': '2 days ago',
      },
      {
        'name': 'Priya Sharma',
        'avatar': 'PS',
        'rating': 4,
        'comment': 'Smooth ride, comfortable seats. Good experience overall.',
        'date': '1 week ago',
      },
      {
        'name': 'Arun Prasad',
        'avatar': 'AP',
        'rating': 5,
        'comment': 'Excellent service, car was in perfect condition.',
        'date': '2 weeks ago',
      },
    ]);
  }

  void loadImages() {
    images.assignAll([
      imagePath.value ?? '',
      AppAssetsConstants.car,
      AppAssetsConstants.car2,
    ]);
  }

  List<String?> get vehicleImages => [
    imagePath.value,
    AppAssetsConstants.car,
    AppAssetsConstants.car2,
    null,
  ];

  // Getters for screen
  String get fare_km => '${fare.value}/km';
  String get rating_value => rating.value;
  String get capacity_value => seatingCapacity.value;
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
      Routes.carBooking,
      arguments: {
        'vehicleName': name.value,
        'vehicleNumber': vehicleNumber.value,
        'basePrice': basePrice.value,
        'extraKmCharge': extraKmCharge.value,
        'extraHourCharge': extraHourCharge.value,
        'driverBata': driverBata.value,
        'fare': fare.value,
        'imagePath': imagePath.value,
      },
    );
  }
}
