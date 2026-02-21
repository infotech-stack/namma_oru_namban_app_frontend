import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/presentation/controller/vehicle_detailse_controller.dart';

class VehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleDetailController>(() => VehicleDetailController());
  }
}
