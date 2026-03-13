// lib/features/vehicle_details/tata_ace/bindings/tata_ace_vehicle_detail_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/tata_ace/presentation/controller/tata_ace_vehicle_detail_controller.dart';

class TataAceVehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TataAceVehicleDetailController>(
      () => TataAceVehicleDetailController(),
    );
  }
}
