// lib/features/vehicle_details/bus/bindings/bus_vehicle_detail_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/bus/presentation/controller/bus_vehicle_detail_controller.dart';

class BusVehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusVehicleDetailController>(() => BusVehicleDetailController());
  }
}
