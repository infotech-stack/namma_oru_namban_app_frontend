import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/car/presentation/controller/car_vehicle_detail_controller.dart';

class CarVehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarVehicleDetailController>(() => CarVehicleDetailController());
  }
}
