// lib/features/booking/lorry/bindings/lorry_booking_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/booking_details/lorry/presentation/controller/lorry_booking_controller.dart';

class LorryBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LorryBookingController>(() => LorryBookingController());
  }
}
