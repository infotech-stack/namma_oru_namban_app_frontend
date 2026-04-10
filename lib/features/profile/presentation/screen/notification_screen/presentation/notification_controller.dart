// lib/features/notification/presentation/controller/notification_controller.dart

import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/entities/notification_entity.dart';
import 'package:userapp/features/profile/presentation/screen/notification_screen/domain/usecases/get_notifications_usecase.dart';

import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class NotificationController extends GetxController {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllReadUseCase _markAllReadUseCase;
  final ClearNotificationsUseCase _clearNotificationsUseCase;

  NotificationController({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkAsReadUseCase markAsReadUseCase,
    required MarkAllReadUseCase markAllReadUseCase,
    required ClearNotificationsUseCase clearNotificationsUseCase,
  }) : _getNotificationsUseCase = getNotificationsUseCase,
       _markAsReadUseCase = markAsReadUseCase,
       _markAllReadUseCase = markAllReadUseCase,
       _clearNotificationsUseCase = clearNotificationsUseCase;

  // ── State ──────────────────────────────────────────────────────
  final RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;
  final isLoading = false.obs;
  final isMarkingAll = false.obs;
  final isClearing = false.obs;
  final errorMessage = ''.obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    AppLogger.info('NotificationController → onInit');
    fetchNotifications();
  }

  // ── Fetch ──────────────────────────────────────────────────────
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';

    AppLogger.info('NotificationController → fetchNotifications');

    final result = await _getNotificationsUseCase();

    if (result.isSuccess && result.data != null) {
      notifications.assignAll(result.data!.notifications);
      unreadCount.value = result.data!.unreadCount;
      AppLogger.info(
        'NotificationController → fetchNotifications: success — '
        '${notifications.length} items, unread=${unreadCount.value}',
      );
    } else {
      errorMessage.value = result.error ?? 'failed_to_load_notifications'.tr;
      AppLogger.error(
        'NotificationController → fetchNotifications: FAILED — ${errorMessage.value}',
      );
    }

    isLoading.value = false;
  }

  // ── Mark single as read ────────────────────────────────────────
  Future<void> markAsRead(NotificationEntity notification) async {
    if (notification.isRead) return;

    AppLogger.info(
      'NotificationController → markAsRead: id=${notification.id}',
    );

    // Optimistic update
    final index = notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      notifications[index] = NotificationEntity(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        type: notification.type,
        data: notification.data,
        isRead: true,
        createdAt: notification.createdAt,
      );
      if (unreadCount.value > 0) unreadCount.value--;
    }

    final result = await _markAsReadUseCase(notification.id);
    if (!result.isSuccess) {
      // Revert on failure
      AppLogger.error(
        'NotificationController → markAsRead: FAILED — ${result.error}',
      );
      await fetchNotifications();
    }
  }

  // ── Mark all as read ──────────────────────────────────────────
  Future<void> markAllAsRead() async {
    if (unreadCount.value == 0) return;

    isMarkingAll.value = true;
    AppLogger.info('NotificationController → markAllAsRead');

    final result = await _markAllReadUseCase();

    if (result.isSuccess) {
      // Optimistic update
      notifications.assignAll(
        notifications
            .map(
              (n) => NotificationEntity(
                id: n.id,
                title: n.title,
                body: n.body,
                type: n.type,
                data: n.data,
                isRead: true,
                createdAt: n.createdAt,
              ),
            )
            .toList(),
      );
      unreadCount.value = 0;
      AppLogger.info('NotificationController → markAllAsRead: success');
    } else {
      AppLogger.error(
        'NotificationController → markAllAsRead: FAILED — ${result.error}',
      );
      AppSnackbar.error(
        result.error ?? 'failed_to_mark_all'.tr,
        title: 'error'.tr,
        isRaw: true,
      );
    }

    isMarkingAll.value = false;
  }

  // ── Clear all ─────────────────────────────────────────────────
  Future<void> clearAll() async {
    isClearing.value = true;
    AppLogger.info('NotificationController → clearAll');

    final result = await _clearNotificationsUseCase();

    if (result.isSuccess) {
      notifications.clear();
      unreadCount.value = 0;
      AppLogger.info('NotificationController → clearAll: success');
    } else {
      AppLogger.error(
        'NotificationController → clearAll: FAILED — ${result.error}',
      );
      AppSnackbar.error(
        result.error ?? 'failed_to_clear'.tr,
        title: 'error'.tr,
        isRaw: true,
      );
    }

    isClearing.value = false;
  }

  // ── Tap handler ───────────────────────────────────────────────
  void onNotificationTap(NotificationEntity notification) {
    markAsRead(notification);

    final bookingId = notification.data.bookingId;
    if (bookingId == null) return;

    AppLogger.info(
      'NotificationController → onNotificationTap: '
      'type=${notification.type}, bookingId=$bookingId',
    );

    Get.toNamed(
      Routes.myBookingStatus,
      arguments: {'id': int.tryParse(bookingId) ?? 0},
    );
  }

  // ── Clear dialog ──────────────────────────────────────────────
  void showClearDialog() {
    Get.defaultDialog(
      title: 'clear_notifications'.tr,
      middleText: 'clear_notifications_msg'.tr,
      textConfirm: 'clear'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Get.theme.colorScheme.secondary,
      onConfirm: () {
        Get.back();
        clearAll();
      },
    );
  }
}
