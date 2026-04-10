// lib/features/notification/domain/usecases/get_notifications_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/entities/notification_entity.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository _repository;
  const GetNotificationsUseCase(this._repository);

  Future<ApiResult<NotificationResponseEntity>> call() {
    return _repository.getNotifications();
  }
}

class MarkAsReadUseCase {
  final NotificationRepository _repository;
  const MarkAsReadUseCase(this._repository);

  Future<ApiResult<void>> call(int id) {
    return _repository.markAsRead(id);
  }
}

class MarkAllReadUseCase {
  final NotificationRepository _repository;
  const MarkAllReadUseCase(this._repository);

  Future<ApiResult<void>> call() {
    return _repository.markAllAsRead();
  }
}

class ClearNotificationsUseCase {
  final NotificationRepository _repository;
  const ClearNotificationsUseCase(this._repository);

  Future<ApiResult<void>> call() {
    return _repository.clearAll();
  }
}
