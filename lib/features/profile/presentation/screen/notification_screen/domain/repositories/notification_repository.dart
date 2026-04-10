// lib/features/notification/domain/repositories/notification_repository.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<ApiResult<NotificationResponseEntity>> getNotifications();
  Future<ApiResult<void>> markAsRead(int id);
  Future<ApiResult<void>> markAllAsRead();
  Future<ApiResult<void>> clearAll();
}
