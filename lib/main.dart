// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:userapp/app/my_app.dart';
import 'package:userapp/core/config/env_config.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/storage/hive_service.dart';
import 'package:userapp/utils/services/fcm_token_sevice.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only once
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppLogger.info('✅ Firebase initialized');

  // Initialize Hive Service
  final hiveService = HiveService();
  await hiveService.init();
  Get.put(hiveService, permanent: true);
  AppLogger.info('✅ HiveService initialized');

  // Initialize FCM Service
  final fcmService = FCMService();
  await fcmService.init();
  Get.put(fcmService, permanent: true);
  AppLogger.info('✅ FCMService initialized');

  // Load env
  await dotenv.load(fileName: ".env");
  AppLogger.info('✅ Environment loaded');

  // Debug env values
  AppLogger.info('═══════════════════════════════════════');
  AppLogger.info('🔥 ENV CONFIGURATION 🔥');
  AppLogger.info('═══════════════════════════════════════');
  AppLogger.info('BASE_URL: ${EnvConfig.baseUrl}');
  AppLogger.info(
    'CONNECT_TIMEOUT: ${EnvConfig.connectTimeout}ms (${EnvConfig.connectTimeout / 1000} seconds)',
  );
  AppLogger.info(
    'RECEIVE_TIMEOUT: ${EnvConfig.receiveTimeout}ms (${EnvConfig.receiveTimeout / 1000} seconds)',
  );
  AppLogger.info('═══════════════════════════════════════\n');

  runApp(MyApp());
}
