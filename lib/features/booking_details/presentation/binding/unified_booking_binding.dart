// lib/features/booking/unified/presentation/bindings/unified_booking_binding.dart

import 'package:get/get.dart';
import 'package:userapp/features/booking_details/data/datasources/booking_remote_datasource.dart';
import 'package:userapp/features/booking_details/data/repositories/booking_repository_impl.dart';
import 'package:userapp/features/booking_details/domain/repositories/booking_repository.dart';
import 'package:userapp/features/booking_details/domain/usecases/create_booking_usecase.dart';
import 'package:userapp/features/booking_details/presentation/controller/unified_booking_controller.dart';

class UnifiedBookingBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<BookingRemoteDataSource>(() => BookingRemoteDataSourceImpl());

    // Repositories
    Get.lazyPut<BookingRepository>(() => BookingRepositoryImpl());

    // Use Cases
    Get.lazyPut<CreateBookingUseCase>(() => CreateBookingUseCase(Get.find()));

    // Controllers
    Get.lazyPut<UnifiedBookingController>(
      () => UnifiedBookingController(Get.find<CreateBookingUseCase>()),
    );
  }
}
