// lib/features/booking/agri_equipment/bindings/agri_equipment_booking_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/booking_details/agri_machins/presentation/controller/agri_equipment_booking_controller.dart';

class AgriEquipmentBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgriEquipmentBookingController>(
      () => AgriEquipmentBookingController(),
    );
  }
}
