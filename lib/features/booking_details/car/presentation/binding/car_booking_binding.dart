import 'package:get/get.dart';
import 'package:userapp/features/booking_details/car/presentation/controller/car_booking_controller.dart';

class CarBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarBookingController>(() => CarBookingController());
  }
}
