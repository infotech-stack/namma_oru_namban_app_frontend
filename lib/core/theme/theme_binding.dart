import 'package:get/get.dart';
import 'package:userapp/core/theme/theme_controller.dart';

class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
  }
}
