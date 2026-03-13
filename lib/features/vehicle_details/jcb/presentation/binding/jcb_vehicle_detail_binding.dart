import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/jcb/presentation/controller/jcb_vehicle_detail_controller.dart';

class JcbVehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JcbVehicleDetailController>(() => JcbVehicleDetailController());
  }
}
