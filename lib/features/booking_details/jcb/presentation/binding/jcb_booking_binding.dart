// lib/features/booking/jcb/bindings/jcb_booking_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/booking_details/jcb/presentation/controller/jcb_booking_controller.dart';

class JcbBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JcbBookingController>(() => JcbBookingController());
  }
}
