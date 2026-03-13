// lib/features/vehicle_details/agri_equipment/bindings/agri_equipment_detail_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/agri/presentation/controller/agri_equipment_detail_controller.dart';

class AgriEquipmentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgriEquipmentDetailController>(
      () => AgriEquipmentDetailController(),
    );
  }
}
