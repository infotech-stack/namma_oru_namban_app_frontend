// lib/features/booking/bus/bindings/bus_booking_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/booking_details/bus/presentation/controller/bus_booking_controller.dart';

class BusBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusBookingController>(() => BusBookingController());
  }
}
