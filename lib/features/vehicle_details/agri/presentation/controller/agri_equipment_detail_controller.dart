// lib/features/vehicle_details/agri_equipment/controllers/agri_equipment_detail_controller.dart

import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/constants/app_images.dart';

class AgriEquipmentDetailController extends GetxController {
  // ─── ALL VARIABLES AS Rx - with .value ─────────────────────

  // Vehicle Details
  final name = 'Harvester'.obs;
  final rating = '4.9'.obs;
  final vehicleNumber = 'TN 22 AB 4589'.obs;
  final equipmentType = 'Harvester'.obs;
  final modelName = 'John Deere S760'.obs;
  final capacity = '5 acres/hr'.obs;
  final fuelType = 'Diesel'.obs;
  final condition = 'Excellent'.obs;
  final fare = '1200'.obs;
  final fareUnit = '/hr'.obs;
  final eta = '30'.obs;
  final distance = '3.2'.obs;
  final tripsCompleted = '180'.obs;
  final imagePath = Rx<String?>(null);

  // Pricing
  final basePrice = '₹1200/hr'.obs;
  final extraHourCharge = '₹200/hr'.obs;
  final operatorBata = '₹300'.obs;
  final fuelCharge = 'Included'.obs;

  // Availability
  final availableFrom = '08:00 AM'.obs;
  final availableTo = '06:00 PM'.obs;
  final minBookingHours = '4 hrs'.obs;

  // Suitable For
  final suitableFor = <String>[].obs;

  // Owner Info
  final ownerName = 'Kumar'.obs;
  final ownerRating = '4.9'.obs;
  final ownerTrips = '280'.obs;

  // Description
  final description =
      '''
High-performance harvester perfect for large-scale farming. Efficient harvesting with minimal grain loss. Well-maintained machine with experienced operator. Suitable for paddy, wheat, and other crops.
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
      name.value = args['name'] ?? 'Harvester';
      rating.value = args['rating'] ?? '4.9';
      vehicleNumber.value = args['vehicleNumber'] ?? 'TN 22 AB 4589';
      equipmentType.value = args['equipmentType'] ?? 'Harvester';
      modelName.value = args['modelName'] ?? 'John Deere S760';
      capacity.value = args['capacity'] ?? '5 acres/hr';
      fuelType.value = args['fuelType'] ?? 'Diesel';
      condition.value = args['condition'] ?? 'Excellent';
      fare.value = args['fare'] ?? '1200';
      eta.value = args['eta'] ?? '30';
      distance.value = args['distance'] ?? '3.2';
      tripsCompleted.value = args['tripsCompleted'] ?? '180';
      imagePath.value = args['imagePath'];

      basePrice.value = args['basePrice'] ?? '₹1200/hr';
      extraHourCharge.value = args['extraHourCharge'] ?? '₹200/hr';
      operatorBata.value = args['operatorBata'] ?? '₹300';
      fuelCharge.value = args['fuelCharge'] ?? 'Included';

      availableFrom.value = args['availableFrom'] ?? '08:00 AM';
      availableTo.value = args['availableTo'] ?? '06:00 PM';
      minBookingHours.value = args['minBookingHours'] ?? '4 hrs';

      ownerName.value = args['ownerName'] ?? 'Kumar';
      ownerRating.value = args['ownerRating'] ?? '4.9';
      ownerTrips.value = args['ownerTrips'] ?? '280';
    }

    loadSuitableFor();
    loadSpecs();
    loadReviews();
    loadImages();
  }

  void loadSuitableFor() {
    suitableFor.assignAll(['harvesting', 'threshing', 'reaping', 'combining']);
  }

  void loadSpecs() {
    specs.assignAll([
      {'label': 'equipment_type', 'value': equipmentType.value},
      {'label': 'model_name', 'value': modelName.value},
      {'label': 'capacity', 'value': capacity.value},
      {'label': 'fuel_type', 'value': fuelType.value},
      {'label': 'condition', 'value': condition.value},
      {'label': 'base_price', 'value': basePrice.value},
      {'label': 'extra_hour', 'value': extraHourCharge.value},
      {'label': 'operator_bata', 'value': operatorBata.value},
      {'label': 'fuel_charge', 'value': fuelCharge.value},
    ]);
  }

  void loadReviews() {
    reviews.assignAll([
      {
        'name': 'Kumar',
        'avatar': 'K',
        'rating': 5,
        'comment':
            'Excellent harvester! Completed work quickly and efficiently.',
        'date': '3 days ago',
      },
      {
        'name': 'Ravi',
        'avatar': 'R',
        'rating': 4,
        'comment': 'Good machine, well maintained. Operator was skilled.',
        'date': '1 week ago',
      },
      {
        'name': 'Selvam',
        'avatar': 'S',
        'rating': 5,
        'comment': 'Best agricultural equipment service in our area!',
        'date': '2 weeks ago',
      },
    ]);
  }

  void loadImages() {
    images.assignAll([
      imagePath.value ?? '',
      AppAssetsConstants.agri1,
      AppAssetsConstants.agri2,
    ]);
  }

  List<String?> get vehicleImages => [
    imagePath.value,
    AppAssetsConstants.agri1,
    AppAssetsConstants.agri2,
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
      Routes.agriBooking,
      arguments: {
        'vehicleName': name.value,
        'vehicleNumber': vehicleNumber.value,
        'equipmentType': equipmentType.value,
        'modelName': modelName.value,
        'capacity': capacity.value,
        'basePrice': basePrice.value,
        'extraHourCharge': extraHourCharge.value,
        'operatorBata': operatorBata.value,
        'fuelCharge': fuelCharge.value,
        'fare': fare.value,
        'imagePath': imagePath.value,
        'availableFrom': availableFrom.value,
        'availableTo': availableTo.value,
        'minBookingHours': minBookingHours.value,
      },
    );
  }
}
