// lib/features/vehicle_details/jcb/controllers/jcb_vehicle_detail_controller.dart

import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/constants/app_images.dart';

class JcbVehicleDetailController extends GetxController {
  // ─── ALL VARIABLES AS Rx - with .value ─────────────────────

  // Vehicle Details
  final name = 'JCB 3DX'.obs;
  final rating = '4.8'.obs;
  final vehicleNumber = 'TN 22 AB 4589'.obs;
  final jcbModel = 'JCB 3DX'.obs;
  final machineType = 'Excavator'.obs;
  final bucketType = 'Big Bucket'.obs;
  final fuelType = 'Diesel'.obs;
  final machineAge = '2 years'.obs;
  final condition = 'Excellent'.obs;
  final fare = '800'.obs;
  final fareUnit = '/hr'.obs;
  final eta = '30'.obs;
  final distance = '3.2'.obs;
  final tripsCompleted = '180'.obs;
  final imagePath = Rx<String?>(null);

  // Pricing
  final basePrice = '₹800/hr'.obs;
  final extraHourCharge = '₹200/hr'.obs;
  final operatorBata = '₹300/day'.obs;
  final fuelCharge = 'Included'.obs;

  // Charging Options
  final chargePerHour = true.obs;
  final chargePerLoad = false.obs;

  // Working Areas
  final workingAreas = <String>[].obs;

  // Owner Info
  final ownerName = 'Ramesh'.obs;
  final ownerRating = '4.9'.obs;
  final ownerTrips = '320'.obs;

  // Description
  final description =
      '''
Powerful JCB 3DX excavator perfect for construction, excavation, and digging work. Comes with skilled operator. Suitable for all types of soil and terrain. Well-maintained machine with regular service.
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
      name.value = args['name'] ?? 'JCB 3DX';
      rating.value = args['rating'] ?? '4.8';
      vehicleNumber.value = args['vehicleNumber'] ?? 'TN 22 AB 4589';
      jcbModel.value = args['jcbModel'] ?? 'JCB 3DX';
      bucketType.value = args['bucketType'] ?? 'Big Bucket';
      fuelType.value = args['fuelType'] ?? 'Diesel';
      machineAge.value = args['machineAge'] ?? '2 years';
      condition.value = args['condition'] ?? 'Excellent';
      fare.value = args['fare'] ?? '800';
      eta.value = args['eta'] ?? '30';
      distance.value = args['distance'] ?? '3.2';
      tripsCompleted.value = args['tripsCompleted'] ?? '180';
      imagePath.value = args['imagePath'];

      basePrice.value = args['basePrice'] ?? '₹800/hr';
      extraHourCharge.value = args['extraHourCharge'] ?? '₹200/hr';
      operatorBata.value = args['operatorBata'] ?? '₹300/day';
      fuelCharge.value = args['fuelCharge'] ?? 'Included';

      chargePerHour.value = args['chargePerHour'] ?? true;
      chargePerLoad.value = args['chargePerLoad'] ?? false;

      if (args['workingAreas'] != null) {
        workingAreas.value = List<String>.from(args['workingAreas']);
      } else {
        workingAreas.value = ['Chennai', 'Tambaram', 'Poonamallee'];
      }

      ownerName.value = args['ownerName'] ?? 'Ramesh';
      ownerRating.value = args['ownerRating'] ?? '4.9';
      ownerTrips.value = args['ownerTrips'] ?? '320';
    }

    loadSpecs();
    loadReviews();
    loadImages();
  }

  void loadSpecs() {
    specs.assignAll([
      {'label': 'jcb_model', 'value': jcbModel.value},
      {'label': 'bucket_type', 'value': bucketType.value},
      {'label': 'fuel_type', 'value': fuelType.value},
      {'label': 'machine_age', 'value': machineAge.value},
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
        'name': 'Muthu',
        'avatar': 'M',
        'rating': 5,
        'comment': 'Excellent JCB service! Finished excavation work quickly.',
        'date': '3 days ago',
      },
      {
        'name': 'Karthik',
        'avatar': 'K',
        'rating': 4,
        'comment':
            'Good machine, skilled operator. Worked well in tight space.',
        'date': '1 week ago',
      },
      {
        'name': 'Sundar',
        'avatar': 'S',
        'rating': 5,
        'comment': 'Best JCB for construction work. Highly recommend!',
        'date': '2 weeks ago',
      },
    ]);
  }

  void loadImages() {
    images.assignAll([
      imagePath.value ?? '',
      AppAssetsConstants.jcb,
      AppAssetsConstants.jcb2,
    ]);
  }

  List<String?> get vehicleImages => [
    imagePath.value,
    AppAssetsConstants.jcb,
    AppAssetsConstants.jcb2,
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
      Routes.jcbBooking,
      arguments: {
        'vehicleName': name.value,
        'vehicleNumber': vehicleNumber.value,
        'jcbModel': jcbModel.value,
        'bucketType': bucketType.value,
        'fuelType': fuelType.value,
        'basePrice': basePrice.value,
        'extraHourCharge': extraHourCharge.value,
        'operatorBata': operatorBata.value,
        'fuelCharge': fuelCharge.value,
        'fare': fare.value,
        'imagePath': imagePath.value,
        'chargePerHour': chargePerHour.value,
        'chargePerLoad': chargePerLoad.value,
      },
    );
  }
}
