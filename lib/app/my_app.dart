import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/app_translations.dart';
import 'package:userapp/core/route/app_pages.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/core/theme/theme_binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, child) => GetMaterialApp(
        initialBinding: ThemeBinding(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: const Locale('en'),
        fallbackLocale: const Locale('en'),
        initialRoute: Routes.home,
        getPages: AppPages.pages,
      ),
    );
  }
}
