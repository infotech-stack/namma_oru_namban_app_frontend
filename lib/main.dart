import 'package:flutter/material.dart';
import 'package:userapp/app/my_app.dart';
import 'package:userapp/core/storage/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService().init();

  runApp(MyApp());
}
