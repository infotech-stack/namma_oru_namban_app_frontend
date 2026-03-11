import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/utils/constants/app_images.dart';

class VehicleDetailController extends GetxController {
  // Simple plain variables - no Rx, no model class needed
  String name = '';
  String rating = '';
  String capacity = '';
  String fare = '';
  String eta = '';
  String distance = '3.2';
  String tripsCompleted = '120';
  String? imagePath;

  final specs = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args == null) return;

    // ✅ Read from Map - matches what HomeController sends
    name = args['name'] ?? '';
    rating = args['rating'] ?? '';
    capacity = args['capacity'] ?? '';
    fare = args['fare'] ?? '';
    eta = args['eta'] ?? '';
    distance = args['distance'] ?? '3.2';
    tripsCompleted = args['tripsCompleted'] ?? '120';
    imagePath = args['imagePath'];

    specs.assignAll([
      {'label': 'payload', 'value': '2500kG'},
      {'label': 'cargo_box', 'value': '7.2ft x 6.8ft x 1ft'},
      {'label': 'axle_type', 'value': 'Multi Axle'},
      {'label': 'fuel_type', 'value': 'Diesel'},
      {'label': 'loading_type', 'value': 'Rear Loading'},
      {'label': 'suitable_for', 'value': 'Heavy Goods'},
    ]);
  }

  List<String?> get vehicleImages => [
    imagePath, // main image
    AppAssetsConstants.car, // test image 2
    AppAssetsConstants.car2, // test image 3
    null, // null safety test
  ];

  void onBookNow() {
    Get.toNamed(
      Routes.bookingDetails,
      arguments: {
        // sends all vehicle data
        'name': name,
        'rating': rating,
        'capacity': capacity,
        'fare': fare,
        'eta': eta,
        'distance': distance,
        'imagePath': imagePath ?? '',
      },
    );
  }
}
