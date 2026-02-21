import 'package:get/get.dart';
import 'package:userapp/features/auth/otp/presentation/controller/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(() => OtpController());
  }
}
