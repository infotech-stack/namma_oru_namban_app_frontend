// lib/features/driver/bookings/presentation/binding/driver_booking_binding.dart

import 'package:get/get.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/booking/data/datasources/my_booking_detail_remote_datasource.dart';
import 'package:userapp/features/booking/data/datasources/my_booking_remote_datasource.dart';
import 'package:userapp/features/booking/data/repositories/my_booking_detail_repository_impl.dart';
import 'package:userapp/features/booking/data/repositories/my_booking_repository_impl.dart';
import 'package:userapp/features/booking/domain/repositories/my_booking_detail_repository.dart';
import 'package:userapp/features/booking/domain/repositories/my_booking_repository.dart';
import 'package:userapp/features/booking/domain/usecases/get_booking_detail_usecase.dart';
import 'package:userapp/features/booking/domain/usecases/get_my_bookings_usecase.dart';
import 'package:userapp/features/booking/presentation/controller/driver_booking_list_controller.dart';
import 'package:userapp/features/booking/presentation/controller/driver_booking_status_controller.dart';
import 'package:userapp/features/booking/presentation/controller/my_booking_detail_controller.dart';
import 'package:userapp/features/booking/presentation/controller/my_booking_list_controller.dart';
import 'package:userapp/features/review/driver_review/data/datasources/review_datasource.dart';
import 'package:userapp/features/review/driver_review/data/repositories/review_repository_impl.dart';
import 'package:userapp/features/review/driver_review/domain/repositories/review_repository.dart';
import 'package:userapp/features/review/driver_review/domain/usecases/add_review_usecase.dart';
import 'package:userapp/features/review/driver_review/domain/usecases/get_reviews_usecase.dart';

/// Binding for DriverBookingListScreen
class DriverBookingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverBookingListController>(
      () => DriverBookingListController(),
    );
  }
}

/// Binding for DriverBookingStatusScreen
/// Pass booking via Get.arguments or constructor
class DriverBookingStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverBookingStatusController>(
      () => DriverBookingStatusController(Get.arguments),
    );
  }
}

class MyBookingListBinding extends Bindings {
  @override
  void dependencies() {
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
  }
}

class MyBookingDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiService>()) {
      Get.lazyPut<ApiService>(() => ApiService());
    }

    // ── Booking detail deps ───────────────────────────────────
    if (!Get.isRegistered<MyBookingDetailRemoteDataSource>()) {
      Get.lazyPut<MyBookingDetailRemoteDataSource>(
        () => MyBookingDetailRemoteDataSourceImpl(),
      );
    }

    if (!Get.isRegistered<MyBookingDetailRepository>()) {
      Get.lazyPut<MyBookingDetailRepository>(
        () => MyBookingDetailRepositoryImpl(),
      );
    }

    if (!Get.isRegistered<GetBookingDetailUseCase>()) {
      Get.lazyPut<GetBookingDetailUseCase>(
        () => GetBookingDetailUseCase(Get.find()),
      );
    }

    // ── Review deps — use Get.put (not lazyPut) so they resolve immediately ──
    if (!Get.isRegistered<ReviewRemoteDataSource>()) {
      Get.put<ReviewRemoteDataSource>(
        ReviewRemoteDataSourceImpl(),
        permanent: false,
      );
    }

    if (!Get.isRegistered<ReviewRepository>()) {
      Get.put<ReviewRepository>(
        ReviewRepositoryImpl(ds: Get.find<ReviewRemoteDataSource>()),
        permanent: false,
      );
    }

    if (!Get.isRegistered<AddReviewUseCase>()) {
      Get.put<AddReviewUseCase>(
        AddReviewUseCase(Get.find<ReviewRepository>()),
        permanent: false,
      );
    }

    if (!Get.isRegistered<GetReviewsUseCase>()) {
      Get.put<GetReviewsUseCase>(
        GetReviewsUseCase(Get.find<ReviewRepository>()),
        permanent: false,
      );
    }

    // ── Controller ────────────────────────────────────────────
    Get.lazyPut<MyBookingDetailController>(
      () => MyBookingDetailController(
        getBookingDetailUseCase: Get.find(),
        getReviewsUseCase: Get.find(),
      ),
    );
  }
}
