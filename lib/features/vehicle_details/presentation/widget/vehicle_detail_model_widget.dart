import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';

class VehicleDetailModel {
  final String nameKey;
  final String rating;
  final String capacity;
  final String fare;
  final String eta;
  final String distance;
  final String tripsCompleted;
  final String? imagePath;
  final String categoryKey;
  final Map<String, String> specifications;

  VehicleDetailModel({
    required this.nameKey,
    required this.rating,
    required this.capacity,
    required this.fare,
    required this.eta,
    required this.distance,
    required this.tripsCompleted,
    required this.categoryKey,
    required this.specifications,
    this.imagePath,
  });
}
