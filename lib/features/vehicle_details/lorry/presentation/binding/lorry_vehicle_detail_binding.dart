import 'package:get/get.dart';
import 'package:userapp/features/vehicle_details/lorry/presentation/controller/lorry_vehicle_detail_controller.dart';

class LorryVehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LorryVehicleDetailController>(
      () => LorryVehicleDetailController(),
    );
  }
}
