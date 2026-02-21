import 'package:get/get.dart';
import 'package:userapp/features/auth/login/presentation/binding/login_binding.dart';
import 'package:userapp/features/auth/login/presentation/screen/login_screen.dart';
import 'package:userapp/features/auth/otp/presentation/binding/otp_binding.dart';
import 'package:userapp/features/auth/otp/presentation/screen/otp_screen.dart';
import 'package:userapp/features/auth/signup/binding/signup_binding.dart';
import 'package:userapp/features/auth/signup/screen/signup_screen.dart';
import 'package:userapp/features/home/presentation/binding/home_binding.dart';
import 'package:userapp/features/home/presentation/screens/home_screen.dart';
import 'package:userapp/features/onboarding/splash_screen/splash_screen.dart';
import 'package:userapp/features/vehicle_details/presentation/binding/vehicle_binding.dart';
import 'package:userapp/features/vehicle_details/presentation/screen/vehicle_details_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    /// Splash (No animation)
    GetPage(
      name: Routes.splash,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    /// SignUp
    GetPage(
      name: Routes.signUpScreen,
      page: () => SignUpScreen(),
      binding: SignUpBinding(),
    ),

    /// OTP
    GetPage(
      name: Routes.otpScreen,
      page: () => OtpScreen(),
      binding: OtpBinding(),
    ),

    /// Login
    GetPage(
      name: Routes.loginScreen,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),

    /// Home
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// Vehicle Details Screen
    GetPage(
      name: Routes.vehDetails,
      page: () => VehicleDetailScreen(),
      binding: VehicleDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
