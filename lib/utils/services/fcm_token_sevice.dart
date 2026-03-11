// lib/core/services/fcm_service.dart
//
// Works for BOTH User App and Driver App.
// Just change FCM_TOKEN_ENDPOINT per app.
//
// pubspec.yaml:
//   firebase_core: ^3.x.x
//   firebase_messaging: ^15.x.x
//
// Setup Steps:
//   1. Firebase Console → Project Settings → Add Android app (each app separately)
//   2. Download google-services.json → paste in android/app/
//   3. android/build.gradle → classpath 'com.google.gms:google-services:4.4.x'
//   4. android/app/build.gradle → apply plugin: 'com.google.gms.google-services'

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';

// ── Background message handler (top-level function — must be outside class) ──
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // App background/terminated la notification varum
  AppLogger.info('[FCM Background] ${message.notification?.title}');
}

class FCMService extends GetxService {
  static FCMService get to => Get.find();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Reactive token — UI la use pannalam
  final fcmToken = ''.obs;

  // ── Change this per app ──────────────────────────────────────────────────
  // User App   : '/api/v1/user/bookings/fcm-token'
  // Driver App : '/api/v1/driver/bookings/fcm-token'
  static const String FCM_TOKEN_ENDPOINT = '/api/v1/user/bookings/fcm-token';

  // ── Init ─────────────────────────────────────────────────────────────────

  Future<FCMService> init() async {
    // 1. Background handler register
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Permission request (iOS + Android 13+)
    await _requestPermission();

    // 3. Local notifications setup (Android foreground)
    await _setupLocalNotifications();

    // 4. Foreground message handler
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // 5. Notification tap handler (app in background, user taps)
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTap);

    // 6. App terminated state — notification tap
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationData(initialMessage.data);
    }

    // 7. Token generate + save
    await _generateAndSaveToken();

    // 8. Token refresh listener
    _messaging.onTokenRefresh.listen((newToken) async {
      fcmToken.value = newToken;
      await _saveTokenToBackend(newToken);
    });

    return this;
  }

  // ── Permission ────────────────────────────────────────────────────────────

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    AppLogger.info('[FCM] Permission: ${settings.authorizationStatus}');
  }

  // ── Local Notifications (show notification when app is foreground) ────────

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

    // Android notification channel (high importance = heads-up notification)
    const channel = AndroidNotificationChannel(
      'bookings', // id — fcm.helper.js la same channelId
      'Booking Notifications', // name
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

  // ── Foreground Message Handler ────────────────────────────────────────────

  void _onForegroundMessage(RemoteMessage message) {
    AppLogger.info('[FCM Foreground] ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    // Show local notification (FCM won't show heads-up when app is open)
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

    // In-app snackbar / dialog show pannalam
    _handleNotificationData(message.data);
  }

  // ── Notification Tap (Background) ─────────────────────────────────────────

  void _onNotificationTap(RemoteMessage message) {
    AppLogger.info('[FCM Tap] ${message.data}');
    _handleNotificationData(message.data);
  }

  void _handleNotificationTapFromPayload(String payload) {
    try {
      // Simple key=value parse (we encoded it below)
      final data = Uri.splitQueryString(payload);
      _handleNotificationData(data);
    } catch (e) {
      AppLogger.info('[FCM] Payload parse error: $e');
    }
  }

  // ── Route to correct screen based on notification type ───────────────────
  //
  // Backend fcm.helper.js la send pannra data:
  //   new_booking      → Driver: show booking request screen
  //   booking_accepted → User: navigate to booking tracking
  //   booking_rejected → User: show rejection message
  //   trip_started     → User: show trip ongoing screen
  //   trip_completed   → User: show completion + rating screen
  //   booking_cancelled→ Driver: show cancellation message

  void _handleNotificationData(Map<String, dynamic> data) {
    final type = data['type'] as String? ?? '';
    final bookingId = data['bookingId'] as String? ?? '';

    switch (type) {
      // ── DRIVER APP ──
      case 'new_booking':
        // Driver → New booking request screen
        Get.toNamed(
          '/driver/booking-request',
          arguments: {'bookingId': bookingId, 'data': data},
        );
        break;

      case 'booking_cancelled':
        // Driver → Booking cancelled snackbar
        Get.snackbar(
          '🚫 Booking Cancelled',
          'User cancelled booking ${data['bookingRef'] ?? ''}',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
        break;

      // ── USER APP ──
      case 'booking_accepted':
        // User → Navigate to booking tracking
        Get.toNamed(
          '/user/booking-tracking',
          arguments: {
            'bookingId': bookingId,
            'driverName': data['driverName'] ?? 'Driver',
          },
        );
        break;

      case 'booking_rejected':
        Get.snackbar(
          '❌ Booking Rejected',
          'Driver rejected your booking. Please try another vehicle.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
        break;

      case 'trip_started':
        Get.snackbar(
          '🚀 Trip Started!',
          'Your driver has started the trip.',
          snackPosition: SnackPosition.TOP,
        );
        break;

      case 'trip_completed':
        // User → Navigate to rating screen
        Get.toNamed(
          '/user/trip-complete',
          arguments: {
            'bookingId': bookingId,
            'finalAmount': data['finalAmount'] ?? '0',
          },
        );
        break;
    }
  }

  // ── Generate & Save Token ─────────────────────────────────────────────────

  Future<void> _generateAndSaveToken() async {
    try {
      // iOS → APNS token first venum
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

      // Backend la save pannuvom
      await _saveTokenToBackend(token);
    } catch (e) {
      AppLogger.info('[FCM] Token error: $e');
    }
  }

  // ── Save to Backend ───────────────────────────────────────────────────────
  // GetConnect use pannrom — existing ApiService use pannalum

  Future<void> _saveTokenToBackend(String token) async {
    try {
      // Auth token check — login aana appuram matum save pannuvom
      // GetStorage / SharedPreferences la irunthu auth token edukalam
      final authToken = _getAuthToken();
      if (authToken == null || authToken.isEmpty) {
        AppLogger.info('[FCM] No auth token — will save after login');
        return;
      }

      final connect = GetConnect();
      final response = await connect.post(
        FCM_TOKEN_ENDPOINT,
        {'fcmToken': token, 'deviceType': Platform.isIOS ? 'ios' : 'android'},
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.isOk) {
        AppLogger.info('[FCM] Token saved to backend ✅');
      } else {
        AppLogger.info('[FCM] Backend save failed: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.info('[FCM] Backend save error: $e');
    }
  }

  // ── Call this after login success ─────────────────────────────────────────
  // AuthController la login success aana: FCMService.to.onLoginSuccess()

  Future<void> onLoginSuccess() async {
    if (fcmToken.value.isNotEmpty) {
      await _saveTokenToBackend(fcmToken.value);
    } else {
      await _generateAndSaveToken();
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String? _getAuthToken() {
    // GetStorage use panra case:
    // return GetStorage().read('authToken');

    // SharedPreferences use panra case:
    // return prefs.getString('authToken');

    // Ipo placeholder — your storage method use pannidu
    return null; // ← Replace with your actual token storage read
  }

  String _encodePayload(Map<String, dynamic> data) {
    return data.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
  }
}
