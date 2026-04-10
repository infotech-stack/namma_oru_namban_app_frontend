// lib/features/notification/data/datasources/notification_remote_datasource.dart

import 'package:userapp/core/network/api_constants.dart';
import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/data/model/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationResponseModel> getNotifications();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
  Future<void> clearAll();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService _api;

  NotificationRemoteDataSourceImpl({ApiService? apiService})
    : _api = apiService ?? ApiService();

  // ── GET /user/notifications ───────────────────────────────────
  @override
  Future<NotificationResponseModel> getNotifications() async {
    try {
      final result = await _api.get(ApiConstants.user.notifications);

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>? ?? {};
        return NotificationResponseModel.fromJson(data);
      }

      throw ApiException(
        message: result.error ?? 'Failed to fetch notifications',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  // ── PATCH /user/notifications/:id/read ───────────────────────
  @override
  Future<void> markAsRead(int id) async {
    try {
      final result = await _api.patch(
        '${ApiConstants.user.notifications}/$id/read',
        {},
      );

      if (!result.isSuccess) {
        throw ApiException(
          message: result.error ?? 'Failed to mark as read',
          type: result.exception?.type ?? ApiErrorType.unknown,
          statusCode: result.exception?.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ── PATCH /user/notifications/read-all ───────────────────────
  @override
  Future<void> markAllAsRead() async {
    try {
      final result = await _api.patch(ApiConstants.user.markAllRead, {});

      if (!result.isSuccess) {
        throw ApiException(
          message: result.error ?? 'Failed to mark all as read',
          type: result.exception?.type ?? ApiErrorType.unknown,
          statusCode: result.exception?.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // ── DELETE /user/notifications ────────────────────────────────
  @override
  Future<void> clearAll() async {
    try {
      final result = await _api.delete(ApiConstants.user.notifications);

      if (!result.isSuccess) {
        throw ApiException(
          message: result.error ?? 'Failed to clear notifications',
          type: result.exception?.type ?? ApiErrorType.unknown,
          statusCode: result.exception?.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
