import 'package:get/get.dart';
import 'package:userapp/features/auth/signup/controller/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}
