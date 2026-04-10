import 'package:get/get.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/home/data/datasources/home_remote_datasource.dart';
import 'package:userapp/features/home/data/repositories/home_repository_impl.dart';
import 'package:userapp/features/home/domain/repositories/home_repository.dart';
import 'package:userapp/features/home/domain/usecases/get_vehicle_detail_usecase.dart';
import 'package:userapp/features/review/driver_review/data/datasources/review_datasource.dart';
import 'package:userapp/features/review/driver_review/data/repositories/review_repository_impl.dart';
import 'package:userapp/features/review/driver_review/domain/repositories/review_repository.dart';
import 'package:userapp/features/review/driver_review/domain/usecases/get_reviews_usecase.dart';
import 'package:userapp/features/vehicle_details/presentation/controller/unified_vehicle_detail_controller.dart';

class UnifiedVehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());

    // Data Sources
    // Register dependencies if not already registered
    if (!Get.isRegistered<HomeRemoteDataSource>()) {
      Get.lazyPut<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl());
    }
    if (!Get.isRegistered<HomeRepository>()) {
      Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl());
    }
    if (!Get.isRegistered<GetVehicleDetailUseCase>()) {
      Get.lazyPut<GetVehicleDetailUseCase>(
        () => GetVehicleDetailUseCase(Get.find()),
      );
    }
    // ───────── REVIEWS MODULE ─────────

    // DataSource
    if (!Get.isRegistered<ReviewRemoteDataSource>()) {
      Get.lazyPut<ReviewRemoteDataSource>(() => ReviewRemoteDataSourceImpl());
    }

    // Repository
    if (!Get.isRegistered<ReviewRepository>()) {
      Get.lazyPut<ReviewRepository>(() => ReviewRepositoryImpl());
    }

    // UseCase
    if (!Get.isRegistered<GetReviewsUseCase>()) {
      Get.lazyPut<GetReviewsUseCase>(() => GetReviewsUseCase(Get.find()));
    }
    // Register controller
    Get.lazyPut<UnifiedVehicleDetailController>(
      () => UnifiedVehicleDetailController(
        Get.find<GetVehicleDetailUseCase>(),
        Get.find<GetReviewsUseCase>(),
      ),
      fenix: true,
    );
  }
}
