import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:userapp/app/my_app.dart';
import 'package:userapp/core/config/env_config.dart';
import 'package:userapp/core/storage/hive_service.dart';
import 'package:userapp/utils/services/fcm_token_sevice.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  // 🔥 DEBUG: Print env values
  print('═══════════════════════════════════════');
  print('🔥 ENV CONFIGURATION 🔥');
  print('═══════════════════════════════════════');
  print('BASE_URL: ${EnvConfig.baseUrl}');
  print(
    'CONNECT_TIMEOUT: ${EnvConfig.connectTimeout}ms (${EnvConfig.connectTimeout / 1000} seconds)',
  );
  print(
    'RECEIVE_TIMEOUT: ${EnvConfig.receiveTimeout}ms (${EnvConfig.receiveTimeout / 1000} seconds)',
  );
  print('═══════════════════════════════════════\n');
  await Get.putAsync(() => FCMService().init());
  //await dotenv.load(fileName: ".env");

  await HiveService().init();

  runApp(MyApp());
}
