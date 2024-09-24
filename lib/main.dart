import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_manager/core/app_routes.dart';
import 'package:task_manager/core/dependency.dart';
import 'package:task_manager/global/theme/dark_theme.dart';
import 'package:task_manager/helper/sharedprefarence.dart';

void main() {
  DependancyInjection di = DependancyInjection();

  di.dependencies();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;
  @override
  void initState() {
    token = SharePrefsHelper.getString('token').toString();
    super.initState();
    print(token.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, child) {
        return GetMaterialApp(
          theme: darkModeTheme,
          debugShowCheckedModeBanner: false,
          getPages: AppRoute.routes,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 200),
          navigatorKey: Get.key,
          initialRoute: token!.isNotEmpty ? AppRoute.homeScreen :AppRoute.splashScreen,
               
        );
      },
    );
  }
}
