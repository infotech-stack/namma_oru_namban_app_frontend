// lib/features/booking/tata_ace/bindings/tata_ace_booking_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/booking_details/tata_ace/presentation/controller/tata_ace_booking_controller.dart';

class TataAceBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TataAceBookingController>(() => TataAceBookingController());
  }
}
