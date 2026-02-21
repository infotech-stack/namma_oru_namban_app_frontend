import 'package:get/get.dart';
import 'package:userapp/features/auth/login/presentation/controller/login_scontroller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
