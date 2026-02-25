import 'package:get/get.dart';
import 'package:userapp/features/booking_details/presentation/controller/booking_details_controller.dart';

class BookingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingDetailsController>(() => BookingDetailsController());
  }
}
