// lib/features/main/bindings/main_binding.dart
import 'package:get/get.dart';
import 'package:userapp/features/booking/presentation/controller/booking_controller.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/features/profile/presentation/controller/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => MyBookingController());
    Get.lazyPut(() => ProfileController());
  }
}
