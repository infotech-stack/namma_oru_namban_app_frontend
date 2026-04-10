// lib/features/notification/data/repositories/notification_repository_impl.dart

import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/data/datasources/notification_remote_datasource.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/entities/notification_entity.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  NotificationRepositoryImpl({NotificationRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? NotificationRemoteDataSourceImpl();

  @override
  Future<ApiResult<NotificationResponseEntity>> getNotifications() async {
    try {
      final model = await _dataSource.getNotifications();
      return ApiResult.success(model.toEntity());
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<void>> markAsRead(int id) async {
    try {
      await _dataSource.markAsRead(id);
      return ApiResult.success(null);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<void>> markAllAsRead() async {
    try {
      await _dataSource.markAllAsRead();
      return ApiResult.success(null);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ApiResult<void>> clearAll() async {
    try {
      await _dataSource.clearAll();
      return ApiResult.success(null);
    } on ApiException catch (e) {
      return ApiResult.failure(e.message, exception: e);
    } catch (e) {
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }
}
