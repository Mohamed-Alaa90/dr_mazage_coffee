import 'package:dr_mazage_coffee/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../pages/login/screens/login_page.dart';

class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: const LoginPage(),
          theme: ThemeData(
            primarySwatch: Colors.brown,
            appBarTheme: AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.brown,
              titleTextStyle: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
