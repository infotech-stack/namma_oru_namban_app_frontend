// lib/features/vehicle_details/tractor/bindings/tractor_vehicle_detail_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/tractor/presentation/controller/tractor_vehicle_detail_controller.dart';

class TractorVehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TractorVehicleDetailController>(
      () => TractorVehicleDetailController(),
    );
  }
}
