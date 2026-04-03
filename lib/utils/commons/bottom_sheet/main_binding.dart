// lib/features/main/bindings/main_binding.dart
import 'package:get/get.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/booking/data/datasources/my_booking_remote_datasource.dart';
import 'package:userapp/features/booking/data/repositories/my_booking_repository_impl.dart';
import 'package:userapp/features/booking/domain/repositories/my_booking_repository.dart';
import 'package:userapp/features/booking/domain/usecases/get_my_bookings_usecase.dart';
import 'package:userapp/features/booking/presentation/controller/my_booking_list_controller.dart';
import 'package:userapp/features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'package:userapp/features/favorites/data/repositories/favorites_repositories_impl.dart';
import 'package:userapp/features/favorites/domain/repositories/favoritesRepository.dart';
import 'package:userapp/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:userapp/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:userapp/features/home/data/datasources/home_remote_datasource.dart';
import 'package:userapp/features/home/data/repositories/home_repository_impl.dart';
import 'package:userapp/features/home/domain/repositories/home_repository.dart';
import 'package:userapp/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:userapp/features/home/domain/usecases/get_vehicles_usecase.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/features/profile/presentation/controller/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => HomeController());
    // ════════════════════════════════════════
    // 🔵 HOME MODULE
    // ════════════════════════════════════════
    // 1️⃣ Data Source
    Get.put<HomeRemoteDataSource>(HomeRemoteDataSourceImpl(), permanent: true);

    // 2️⃣ Repository
    Get.put<HomeRepository>(
      HomeRepositoryImpl(dataSource: Get.find<HomeRemoteDataSource>()),
      permanent: true,
    );

    // 3️⃣ UseCases
    Get.put<GetCategoriesUseCase>(
      GetCategoriesUseCase(Get.find<HomeRepository>()),
      permanent: true,
    );

    Get.put<GetVehiclesUseCase>(
      GetVehiclesUseCase(Get.find<HomeRepository>()),
      permanent: true,
    );

    // 4️⃣ Controller
    Get.put<HomeController>(
      HomeController(
        Get.find<GetCategoriesUseCase>(),
        Get.find<GetVehiclesUseCase>(),
      ),
      permanent: true,
    );

    ///=======================================
    if (!Get.isRegistered<ApiService>()) {
      Get.lazyPut<ApiService>(() => ApiService());
    }

    if (!Get.isRegistered<MyBookingRemoteDataSource>()) {
      Get.lazyPut<MyBookingRemoteDataSource>(
        () => MyBookingRemoteDataSourceImpl(),
      );
    }

    if (!Get.isRegistered<MyBookingRepository>()) {
      Get.lazyPut<MyBookingRepository>(() => MyBookingRepositoryImpl());
    }

    if (!Get.isRegistered<GetMyBookingsUseCase>()) {
      Get.lazyPut<GetMyBookingsUseCase>(() => GetMyBookingsUseCase(Get.find()));
    }

    Get.lazyPut<MyBookingListController>(
      () => MyBookingListController(Get.find<GetMyBookingsUseCase>()),
    );
    //Get.lazyPut(() => MyBookingListController());
    Get.lazyPut(() => ProfileController());
    //Get.put<FavoritesController>(FavoritesController(), permanent: true);
    // ════════════════════════════════════════
    // ❤️ FAVORITES MODULE
    // ════════════════════════════════════════
    // 1️⃣ Data Source
    Get.put<FavoritesRemoteDataSource>(
      FavoritesRemoteDataSourceImpl(),
      permanent: true,
    );

    // 2️⃣ Repository
    Get.put<FavoritesRepository>(
      FavoritesRepositoryImpl(Get.find()),
      permanent: true,
    );

    // 3️⃣ UseCases
    Get.put<GetFavoritesUseCase>(
      GetFavoritesUseCase(Get.find()),
      permanent: true,
    );
    Get.put<ToggleFavoriteUseCase>(
      ToggleFavoriteUseCase(Get.find()),
      permanent: true,
    );

    Get.put<FavoritesController>(
      FavoritesController(Get.find(), Get.find()), // ✅ correct constructor
      permanent: true,
    );
  }
}
