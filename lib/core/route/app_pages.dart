import 'package:get/get.dart';
import 'package:userapp/features/auth/login/presentation/binding/login_binding.dart';
import 'package:userapp/features/auth/login/presentation/screen/login_screen.dart';
import 'package:userapp/features/auth/otp/presentation/binding/otp_binding.dart';
import 'package:userapp/features/auth/otp/presentation/screen/otp_screen.dart';
import 'package:userapp/features/auth/signup/binding/signup_binding.dart';
import 'package:userapp/features/auth/signup/screen/signup_screen.dart';
import 'package:userapp/features/booking/presentation/binding/my_booking_binding.dart';
import 'package:userapp/features/booking/presentation/screen/my_booking_detail_screen.dart';
import 'package:userapp/features/booking/presentation/screen/my_booking_list_screen.dart';
import 'package:userapp/features/booking_details/presentation/binding/booking_details_binding.dart';
import 'package:userapp/features/booking_details/presentation/binding/unified_booking_binding.dart';
import 'package:userapp/features/booking_details/presentation/screen/booking_details_screen.dart';
import 'package:userapp/features/booking_details/presentation/screen/location_picker_screen.dart';
import 'package:userapp/features/booking_details/presentation/screen/unified_booking_screen.dart';
import 'package:userapp/features/favorites/presentation/screen/favorites_screen.dart';
import 'package:userapp/features/home/presentation/screens/home_screen.dart';
import 'package:userapp/features/onboarding/splash_screen/splash_screen.dart';
import 'package:userapp/features/profile/presentation/screen/address/presentation/address_binding.dart';
import 'package:userapp/features/profile/presentation/screen/address/presentation/address_screen.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/presentation/notification_binding.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/presentation/notification_screen.dart';
import 'package:userapp/features/vehicle_details/presentation/binding/vehicle_binding.dart';
import 'package:userapp/features/vehicle_details/presentation/screen/similar_vehicles_screen.dart';
import 'package:userapp/features/vehicle_details/presentation/screen/unified_vehicle_detail_screen.dart';

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
      //binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// My Booking Screen
    GetPage(
      name: Routes.myBooking,
      page: () => MyBookingListScreen(),
      binding: MyBookingListBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    /// My Booking Status Screen
    GetPage(
      name: Routes.myBookingStatus,
      page: () => MyBookingDetailScreen(),
      binding: MyBookingDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    ///Unified  Booking Details Screen
    GetPage(
      name: Routes.unifiedBooking,
      page: () => UnifiedBookingScreen(),
      binding: UnifiedBookingBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: Routes.similarVehicles,
      page: () => const SimilarVehiclesScreen(),
      // No binding needed — no controller
    ),

    GetPage(
      name: Routes.locationPicker,
      page: () => const LocationPickerScreen(),
    ),
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
      name: Routes.unifiedVehicleDetail,
      page: () => const UnifiedVehicleDetailScreen(),
      binding: UnifiedVehicleDetailBinding(),
    ),

    ///Notification screem
    GetPage(
      name: Routes.notification,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),

    ///Address screen
    GetPage(
      name: Routes.addresses,
      page: () => const AddressScreen(),
      binding: AddressBinding(),
    ),
  ];
}
