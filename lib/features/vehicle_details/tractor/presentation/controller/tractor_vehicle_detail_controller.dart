// lib/features/vehicle_details/tractor/controllers/tractor_vehicle_detail_controller.dart

import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/constants/app_images.dart';

class TractorVehicleDetailController extends GetxController {
  // ─── ALL VARIABLES AS Rx - with .value ─────────────────────

  // Vehicle Details
  final name = 'Mahindra 475'.obs;
  final rating = '4.8'.obs;
  final vehicleNumber = 'TN 22 AB 4589'.obs;
  final tractorCategory = '4WD Tractor'.obs;
  final brand = 'Mahindra'.obs;
  final horsePower = '45 HP'.obs;
  final attachment = 'Rotavator'.obs;
  final fare = '700'.obs;
  final fareUnit = '/hr'.obs;
  final eta = '25'.obs;
  final distance = '3.2'.obs;
  final tripsCompleted = '280'.obs;
  final imagePath = Rx<String?>(null);

  // Pricing
  final basePrice = '₹700/hr'.obs;
  final availableHours = '8 hrs/day'.obs;
  final minHours = '3 hrs'.obs;
  final operatorCharge = '₹300'.obs;

  // Suitable For
  final suitableFor = <String>[].obs;

  // Owner Info
  final ownerName = 'Velmurugan'.obs;
  final ownerRating = '4.9'.obs;
  final ownerTrips = '380'.obs;

  // Description
  final description =
      '''
Powerful Mahindra 475 tractor perfect for all agricultural needs. Ideal for ploughing, tilling, and farm operations. Comes with experienced operator and various attachments. Fuel efficient and well-maintained.
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
      name.value = args['name'] ?? 'Mahindra 475';
      rating.value = args['rating'] ?? '4.8';
      vehicleNumber.value = args['vehicleNumber'] ?? 'TN 22 AB 4589';
      tractorCategory.value = args['tractorCategory'] ?? '4WD Tractor';
      brand.value = args['brand'] ?? 'Mahindra';
      horsePower.value = args['horsePower'] ?? '45 HP';
      attachment.value = args['attachment'] ?? 'Rotavator';
      fare.value = args['fare'] ?? '700';
      eta.value = args['eta'] ?? '25';
      distance.value = args['distance'] ?? '3.2';
      tripsCompleted.value = args['tripsCompleted'] ?? '280';
      imagePath.value = args['imagePath'];

      basePrice.value = args['basePrice'] ?? '₹700/hr';
      availableHours.value = args['availableHours'] ?? '8 hrs/day';
      minHours.value = args['minHours'] ?? '3 hrs';
      operatorCharge.value = args['operatorCharge'] ?? '₹300';

      ownerName.value = args['ownerName'] ?? 'Velmurugan';
      ownerRating.value = args['ownerRating'] ?? '4.9';
      ownerTrips.value = args['ownerTrips'] ?? '380';
    }

    loadSuitableFor();
    loadSpecs();
    loadReviews();
    loadImages();
  }

  void loadSuitableFor() {
    suitableFor.assignAll([
      'ploughing',
      'tilling',
      'harvesting',
      'transport',
      'spraying',
    ]);
  }

  void loadSpecs() {
    specs.assignAll([
      {'label': 'tractor_category', 'value': tractorCategory.value},
      {'label': 'tractor_brand', 'value': brand.value},
      {'label': 'tractor_hp', 'value': horsePower.value},
      {'label': 'tractor_attachment', 'value': attachment.value},
      {'label': 'base_price', 'value': basePrice.value},
      {'label': 'available_hours', 'value': availableHours.value},
      {'label': 'min_hours', 'value': minHours.value},
      {'label': 'operator_charge', 'value': operatorCharge.value},
    ]);
  }

  void loadReviews() {
    reviews.assignAll([
      {
        'name': 'Velmurugan',
        'avatar': 'V',
        'rating': 5,
        'comment':
            'Excellent tractor! Powerful and fuel efficient. Operator was skilled.',
        'date': '2 days ago',
      },
      {
        'name': 'Selvam',
        'avatar': 'S',
        'rating': 4,
        'comment': 'Good for ploughing. Completed work on time.',
        'date': '1 week ago',
      },
      {
        'name': 'Muthu',
        'avatar': 'M',
        'rating': 5,
        'comment': 'Best tractor service in our area. Highly recommended!',
        'date': '2 weeks ago',
      },
    ]);
  }

  void loadImages() {
    images.assignAll([
      imagePath.value ?? '',
      AppAssetsConstants.tractor,
      AppAssetsConstants.tractor2,
    ]);
  }

  List<String?> get vehicleImages => [
    imagePath.value,
    AppAssetsConstants.tractor,
    AppAssetsConstants.tractor2,
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
      Routes.tractorBooking,
      arguments: {
        'vehicleName': name.value,
        'vehicleNumber': vehicleNumber.value,
        'tractorCategory': tractorCategory.value,
        'brand': brand.value,
        'horsePower': horsePower.value,
        'attachment': attachment.value,
        'basePrice': basePrice.value,
        'availableHours': availableHours.value,
        'minHours': minHours.value,
        'operatorCharge': operatorCharge.value,
        'fare': fare.value,
        'imagePath': imagePath.value,
      },
    );
  }
}
