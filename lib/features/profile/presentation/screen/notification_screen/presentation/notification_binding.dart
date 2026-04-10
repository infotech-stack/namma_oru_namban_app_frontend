// lib/features/notification/presentation/binding/notification_binding.dart

import 'package:get/get.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/data/datasources/notification_remote_datasource.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/data/repositories/notification_repository_impl.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/repositories/notification_repository.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/usecases/get_notifications_usecase.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/presentation/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiService>()) {
      Get.put<ApiService>(ApiService());
    }

    if (!Get.isRegistered<NotificationRemoteDataSource>()) {
      Get.put<NotificationRemoteDataSource>(NotificationRemoteDataSourceImpl());
    }

    if (!Get.isRegistered<NotificationRepository>()) {
      Get.put<NotificationRepository>(
        NotificationRepositoryImpl(
          dataSource: Get.find<NotificationRemoteDataSource>(),
        ),
      );
    }

    if (!Get.isRegistered<GetNotificationsUseCase>()) {
      Get.put<GetNotificationsUseCase>(GetNotificationsUseCase(Get.find()));
    }

    if (!Get.isRegistered<MarkAsReadUseCase>()) {
      Get.put<MarkAsReadUseCase>(MarkAsReadUseCase(Get.find()));
    }

    if (!Get.isRegistered<MarkAllReadUseCase>()) {
      Get.put<MarkAllReadUseCase>(MarkAllReadUseCase(Get.find()));
    }

    if (!Get.isRegistered<ClearNotificationsUseCase>()) {
      Get.put<ClearNotificationsUseCase>(ClearNotificationsUseCase(Get.find()));
    }

    Get.lazyPut<NotificationController>(
      () => NotificationController(
        getNotificationsUseCase: Get.find(),
        markAsReadUseCase: Get.find(),
        markAllReadUseCase: Get.find(),
        clearNotificationsUseCase: Get.find(),
      ),
    );
  }
}
