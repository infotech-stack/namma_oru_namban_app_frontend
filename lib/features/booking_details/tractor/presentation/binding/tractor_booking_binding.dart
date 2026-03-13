// lib/features/booking/tractor/bindings/tractor_booking_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/booking_details/tractor/presentation/controller/tractor_booking_controller.dart';

class TractorBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TractorBookingController>(() => TractorBookingController());
  }
}