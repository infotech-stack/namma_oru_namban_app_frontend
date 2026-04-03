// lib/utils/services/fcm_token_sevice.dart

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/network/dio_client.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/storage/hive_service.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.info('[FCM Background] ${message.notification?.title}');
}

class FCMService extends GetxService {
  static FCMService get to => Get.find();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final fcmToken = ''.obs;

  static const String FCM_TOKEN_ENDPOINT = '/user/bookings/fcm-token';

  final List<Map<String, dynamic>> _pendingNotifications = [];
  bool _isAppReady = false;
  bool _isInitialized = false;

  Future<FCMService> init() async {
    if (_isInitialized) return this;

    // 1. Background handler register
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Permission request
    await _requestPermission();

    // 3. Local notifications setup
    await _setupLocalNotifications();

    // 4. Foreground message handler
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // 5. Notification tap handler
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTap);

    // 6. App terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _pendingNotifications.add(initialMessage.data);
      AppLogger.info('[FCM] Stored initial message');
    }

    // 7. Token generate + save (don't await, let it run in background)
    _generateAndSaveToken();

    // 8. Token refresh listener
    _messaging.onTokenRefresh.listen((newToken) async {
      fcmToken.value = newToken;
      await _saveTokenToBackend(newToken);
    });

    _isInitialized = true;
    return this;
  }

  void onAppReady() {
    _isAppReady = true;
    AppLogger.info('[FCM] ✅ App is ready');

    if (_pendingNotifications.isNotEmpty) {
      for (final data in _pendingNotifications) {
        _handleNotificationData(data);
      }
      _pendingNotifications.clear();
    }
  }

  void _handleNotificationWithDelay(Map<String, dynamic> data) {
    if (_isAppReady && Get.context != null) {
      _handleNotificationData(data);
    } else {
      _pendingNotifications.add(data);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    AppLogger.info('[FCM] Permission: ${settings.authorizationStatus}');
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      settings: InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleNotificationTapFromPayload(response.payload!);
        }
      },
    );

    const channel = AndroidNotificationChannel(
      'bookings',
      'Booking Notifications',
      description: 'Heavy vehicle booking updates',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  void _onForegroundMessage(RemoteMessage message) {
    AppLogger.info('[FCM Foreground] ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'bookings',
          'Booking Notifications',
          channelDescription: 'Heavy vehicle booking updates',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: _encodePayload(message.data),
    );

    _handleNotificationWithDelay(message.data);
  }

  void _onNotificationTap(RemoteMessage message) {
    AppLogger.info('[FCM Tap] ${message.data}');
    _handleNotificationWithDelay(message.data);
  }

  void _handleNotificationTapFromPayload(String payload) {
    try {
      final data = Uri.splitQueryString(payload);
      _handleNotificationWithDelay(data);
    } catch (e) {
      AppLogger.info('[FCM] Payload parse error: $e');
    }
  }

  void _handleNotificationData(Map<String, dynamic> data) {
    if (!_isAppReady || Get.context == null) {
      _pendingNotifications.add(data);
      return;
    }

    final type = data['type'] as String? ?? '';
    final bookingIdStr = data['bookingId'] as String? ?? '';
    final bookingId = int.tryParse(bookingIdStr) ?? 0;

    AppLogger.info('[FCM] Processing: type=$type, bookingId=$bookingId');

    switch (type) {
      case 'booking_accepted':
        if (bookingId > 0) {
          Future.microtask(() {
            try {
              Get.toNamed(Routes.myBookingStatus, arguments: bookingId);
              AppSnackbar.success("Your booking accepted");
            } catch (e) {
              AppLogger.error('[FCM] Navigation error: $e');
            }
          });
        }
        break;

      case 'trip_completed':
        if (bookingId > 0) {
          Future.microtask(() {
            try {
              Get.toNamed(Routes.myBookingStatus, arguments: bookingId);
            } catch (e) {
              AppLogger.error('[FCM] Navigation error: $e');
            }
          });
        }
        break;

      case 'booking_rejected':
        AppSnackbar.error(
          "Driver rejected your booking.",
          title: "❌ Booking Rejected",
          isRaw: true,
        );
        break;

      case 'trip_started':
        AppSnackbar.success(
          "Your driver has started the trip.",
          title: "🚀 Trip Started!",
          isRaw: true,
        );
        break;

      default:
        break;
    }
  }

  Future<void> _generateAndSaveToken() async {
    try {
      if (Platform.isIOS) {
        await _messaging.getAPNSToken();
      }

      final token = await _messaging.getToken();
      if (token == null) {
        AppLogger.info('[FCM] Token generation failed');
        return;
      }

      fcmToken.value = token;
      AppLogger.info('[FCM] Token: ${token.substring(0, 20)}...');

      // Don't await, let it run in background
      _saveTokenToBackend(token);
    } catch (e) {
      AppLogger.error('[FCM] Token error: $e');
    }
  }

  Future<void> _saveTokenToBackend(String token) async {
    try {
      // Check if user is logged in
      final hiveService = Get.isRegistered<HiveService>()
          ? Get.find<HiveService>()
          : null;

      if (hiveService == null) {
        AppLogger.info('[FCM] HiveService not registered yet');
        return;
      }

      final authToken = hiveService.getAccessToken();
      if (authToken.isEmpty) {
        AppLogger.info('[FCM] No auth token — will save after login');
        return;
      }

      // Initialize DioClient if needed
      final dioClient = DioClient();

      final response = await dioClient.dio.post(
        FCM_TOKEN_ENDPOINT,
        data: {
          'fcmToken': token,
          'deviceType': Platform.isIOS ? 'ios' : 'android',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('[FCM] Token saved ✅');
      } else {
        AppLogger.info('[FCM] Token save failed: ${response.statusCode}');
      }
    } catch (e) {
      // Don't throw, just log
      AppLogger.error('[FCM] Save error: $e');
    }
  }

  Future<void> onLoginSuccess() async {
    if (fcmToken.value.isNotEmpty) {
      await _saveTokenToBackend(fcmToken.value);
    } else {
      await _generateAndSaveToken();
    }
  }

  String _encodePayload(Map<String, dynamic> data) {
    return data.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }
}
