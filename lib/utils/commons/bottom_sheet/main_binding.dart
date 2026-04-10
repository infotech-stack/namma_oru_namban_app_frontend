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
import 'package:userapp/features/profile/presentation/screen/notification_screen/data/repositories/notification_repository_impl.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/repositories/notification_repository.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/usecases/get_notifications_usecase.dart';

import 'package:userapp/features/profile/presentation/screen/notification_screen/data/datasources/notification_remote_datasource.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // ── Shared ────────────────────────────────────────────────
    Get.put<ApiService>(ApiService(), permanent: true);

    // ════════════════════════════════════════════════════════
    // 🔵 HOME MODULE
    // ════════════════════════════════════════════════════════

    Get.put<HomeRemoteDataSource>(HomeRemoteDataSourceImpl(), permanent: true);

    Get.put<HomeRepository>(
      HomeRepositoryImpl(dataSource: Get.find<HomeRemoteDataSource>()),
      permanent: true,
    );

    Get.put<GetCategoriesUseCase>(
      GetCategoriesUseCase(Get.find<HomeRepository>()),
      permanent: true,
    );

    Get.put<GetVehiclesUseCase>(
      GetVehiclesUseCase(Get.find<HomeRepository>()),
      permanent: true,
    );

    // ════════════════════════════════════════════════════════
    // 🔔 NOTIFICATION MODULE
    // ← Must be registered BEFORE HomeController
    // ════════════════════════════════════════════════════════

    Get.put<NotificationRemoteDataSource>(
      NotificationRemoteDataSourceImpl(),
      permanent: true,
    );

    Get.put<NotificationRepository>(
      NotificationRepositoryImpl(
        dataSource: Get.find<NotificationRemoteDataSource>(),
      ),
      permanent: true,
    );

    Get.put<GetNotificationsUseCase>(
      GetNotificationsUseCase(Get.find<NotificationRepository>()),
      permanent: true,
    );

    // ════════════════════════════════════════════════════════
    // 🏠 HOME CONTROLLER
    // ← Now GetNotificationsUseCase is available ✅
    // ════════════════════════════════════════════════════════

    Get.put<HomeController>(
      HomeController(
        Get.find<GetCategoriesUseCase>(),
        Get.find<GetVehiclesUseCase>(),
        Get.find<GetNotificationsUseCase>(),
      ),
      permanent: true,
    );

    // ════════════════════════════════════════════════════════
    // 📦 BOOKING MODULE
    // ════════════════════════════════════════════════════════

    if (!Get.isRegistered<MyBookingRemoteDataSource>()) {
      Get.put<MyBookingRemoteDataSource>(MyBookingRemoteDataSourceImpl());
    }

    if (!Get.isRegistered<MyBookingRepository>()) {
      Get.put<MyBookingRepository>(MyBookingRepositoryImpl());
    }

    if (!Get.isRegistered<GetMyBookingsUseCase>()) {
      Get.put<GetMyBookingsUseCase>(
        GetMyBookingsUseCase(Get.find<MyBookingRepository>()),
      );
    }

    Get.lazyPut<MyBookingListController>(
      () => MyBookingListController(Get.find<GetMyBookingsUseCase>()),
    );

    // ════════════════════════════════════════════════════════
    // ❤️ FAVORITES MODULE
    // ════════════════════════════════════════════════════════

    Get.put<FavoritesRemoteDataSource>(
      FavoritesRemoteDataSourceImpl(),
      permanent: true,
    );

    Get.put<FavoritesRepository>(
      FavoritesRepositoryImpl(Get.find()),
      permanent: true,
    );

    Get.put<GetFavoritesUseCase>(
      GetFavoritesUseCase(Get.find()),
      permanent: true,
    );

    Get.put<ToggleFavoriteUseCase>(
      ToggleFavoriteUseCase(Get.find()),
      permanent: true,
    );

    Get.put<FavoritesController>(
      FavoritesController(Get.find(), Get.find()),
      permanent: true,
    );

    // ════════════════════════════════════════════════════════
    // 👤 PROFILE
    // ════════════════════════════════════════════════════════

    Get.lazyPut(() => ProfileController());
  }
}
