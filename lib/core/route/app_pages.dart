import 'package:get/get.dart';
import 'package:userapp/features/auth/login/presentation/binding/login_binding.dart';
import 'package:userapp/features/auth/login/presentation/screen/login_screen.dart';
import 'package:userapp/features/auth/otp/presentation/binding/otp_binding.dart';
import 'package:userapp/features/auth/otp/presentation/screen/otp_screen.dart';
import 'package:userapp/features/auth/signup/binding/signup_binding.dart';
import 'package:userapp/features/auth/signup/screen/signup_screen.dart';
import 'package:userapp/features/booking/presentation/binding/my_booking_binding.dart';
import 'package:userapp/features/booking/presentation/screen/my_booking_screen.dart';
import 'package:userapp/features/booking_details/agri_machins/presentation/binding/agri_equipment_booking_binding.dart';
import 'package:userapp/features/booking_details/agri_machins/presentation/screen/agri_equipment_booking_screen.dart';
import 'package:userapp/features/booking_details/bus/presentation/binding/bus_booking_binding.dart';
import 'package:userapp/features/booking_details/bus/presentation/screen/bus_booking_screen.dart';
import 'package:userapp/features/booking_details/car/presentation/binding/car_booking_binding.dart';
import 'package:userapp/features/booking_details/car/presentation/screen/car_booking_screen.dart';
import 'package:userapp/features/booking_details/jcb/presentation/binding/jcb_booking_binding.dart';
import 'package:userapp/features/booking_details/jcb/presentation/screen/jcb_booking_screen.dart';
import 'package:userapp/features/booking_details/lorry/presentation/binding/lorry_booking_binding.dart';
import 'package:userapp/features/booking_details/lorry/presentation/screen/lorry_booking_screen.dart';
import 'package:userapp/features/booking_details/presentation/binding/booking_details_binding.dart';
import 'package:userapp/features/booking_details/presentation/screen/booking_details_screen.dart';
import 'package:userapp/features/booking_details/tata_ace/presentation/binding/tata_ace_booking_binding.dart';
import 'package:userapp/features/booking_details/tata_ace/presentation/screen/tata_ace_booking_screen.dart';
import 'package:userapp/features/booking_details/tractor/presentation/binding/tractor_booking_binding.dart';
import 'package:userapp/features/booking_details/tractor/presentation/screen/tractor_booking_screen.dart';
import 'package:userapp/features/favorites/presentation/screen/favorites_screen.dart';
import 'package:userapp/features/home/presentation/binding/home_binding.dart';
import 'package:userapp/features/home/presentation/screens/home_screen.dart';
import 'package:userapp/features/onboarding/splash_screen/splash_screen.dart';
import 'package:userapp/features/vehicle_details/agri/presentation/binding/agri_equipment_detail_binding.dart';
import 'package:userapp/features/vehicle_details/agri/presentation/screen/agri_equipment_detail_screen.dart';
import 'package:userapp/features/vehicle_details/bus/presentation/binding/bus_vehicle_detail_binding.dart';
import 'package:userapp/features/vehicle_details/bus/presentation/screen/bus_vehicle_detail_screen.dart';
import 'package:userapp/features/vehicle_details/car/presentation/binding/car_vehicle_detail_binding.dart';
import 'package:userapp/features/vehicle_details/car/presentation/screen/car_vehicle_detail_screen.dart';
import 'package:userapp/features/vehicle_details/jcb/presentation/binding/jcb_vehicle_detail_binding.dart';
import 'package:userapp/features/vehicle_details/jcb/presentation/screen/jcb_vehicle_detail_screen.dart';
import 'package:userapp/features/vehicle_details/lorry/presentation/binding/lorry_vehicle_detail_binding.dart';
import 'package:userapp/features/vehicle_details/lorry/presentation/screen/lorry_vehicle_detail_screen.dart';
import 'package:userapp/features/vehicle_details/presentation/binding/vehicle_binding.dart';
import 'package:userapp/features/vehicle_details/presentation/screen/vehicle_details_screen.dart';
import 'package:userapp/features/vehicle_details/tata_ace/presentation/binding/tata_ace_vehicle_detail_binding.dart';
import 'package:userapp/features/vehicle_details/tata_ace/presentation/screen/tata_ace_vehicle_detail_screen.dart';
import 'package:userapp/features/vehicle_details/tractor/presentation/binding/tractor_vehicle_detail_binding.dart';
import 'package:userapp/features/vehicle_details/tractor/presentation/screen/tractor_vehicle_detail_screen.dart';
import 'package:userapp/utils/commons/bottom_sheet/main_binding.dart';
import 'package:userapp/utils/commons/bottom_sheet/main_wrapper.dart';

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

    /// SignUp
    GetPage(
      name: Routes.wrapper,
      page: () => MainWrapper(),
      binding: MainBinding(),
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

    /// My Booking Screen
    GetPage(
      name: Routes.myBooking,
      page: () => MyBookingScreen(),
      binding: MyBookingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    ///  Booking Details Screen
    GetPage(
      name: Routes.bookingDetails,
      page: () => BookingDetailsScreen(),
      binding: BookingDetailsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    ///  Favorites Screen
    GetPage(name: Routes.favorites, page: () => FavoritesScreen()),

    /// All Vehicles Details and Booking Screens
    GetPage(
      name: Routes.carVehicleDetail,
      page: () => CarVehicleDetailScreen(),
      binding: CarVehicleDetailBinding(),
    ),
    GetPage(
      name: Routes.carBooking,
      page: () => const CarBookingScreen(),
      binding: CarBookingBinding(),
    ),
    //
    GetPage(
      name: Routes.busVehicleDetail,
      page: () => BusVehicleDetailScreen(),
      binding: BusVehicleDetailBinding(),
    ),
    GetPage(
      name: Routes.busBooking,
      page: () => const BusBookingScreen(),
      binding: BusBookingBinding(),
    ),
    //
    GetPage(
      name: Routes.jcbVehicleDetail,
      page: () => JcbVehicleDetailScreen(),
      binding: JcbVehicleDetailBinding(),
    ),
    GetPage(
      name: Routes.jcbBooking,
      page: () => const JcbBookingScreen(),
      binding: JcbBookingBinding(),
    ),
    //
    GetPage(
      name: Routes.lorryVehicleDetail,
      page: () => LorryVehicleDetailScreen(),
      binding: LorryVehicleDetailBinding(),
    ),

    ///LORRY BOOKING SCREEN
    GetPage(
      name: Routes.lorryBooking,
      page: () => const LorryBookingScreen(),
      binding: LorryBookingBinding(),
    ),
    //
    GetPage(
      name: Routes.tataAceVehicleDetail,
      page: () => TataAceVehicleDetailScreen(),
      binding: TataAceVehicleDetailBinding(),
    ),
    GetPage(
      name: Routes.tataAceBooking,
      page: () => const TataAceBookingScreen(),
      binding: TataAceBookingBinding(),
    ),
    //
    GetPage(
      name: Routes.tractorVehicleDetail,
      page: () => TractorVehicleDetailScreen(),
      binding: TractorVehicleDetailBinding(),
    ),
    GetPage(
      name: Routes.tractorBooking,
      page: () => const TractorBookingScreen(),
      binding: TractorBookingBinding(),
    ),
    //
    GetPage(
      name: Routes.agriVehicleDetail,
      page: () => AgriEquipmentDetailScreen(),
      binding: AgriEquipmentDetailBinding(),
    ),
    GetPage(
      name: Routes.agriBooking,
      page: () => const AgriEquipmentBookingScreen(),
      binding: AgriEquipmentBookingBinding(),
    ),
  ];
}
