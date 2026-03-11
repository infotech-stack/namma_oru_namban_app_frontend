import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/app/my_app.dart';
import 'package:userapp/core/storage/hive_service.dart';
import 'package:userapp/utils/services/fcm_token_sevice.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Get.putAsync(() => FCMService().init());

  await HiveService().init();

  runApp(MyApp());
}
