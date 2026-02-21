import 'package:get/get.dart';
import 'package:userapp/features/booking/presentation/controller/booking_controller.dart';

class MyBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBookingController>(() => MyBookingController());
  }
}
