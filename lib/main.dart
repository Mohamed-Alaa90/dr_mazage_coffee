import 'package:dr_mazage_coffee/cubit/product/product_cubit.dart';
import 'package:dr_mazage_coffee/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://twmlwyugpopwvdbsjylg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR3bWx3eXVncG9wd3ZkYnNqeWxnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQzMTAzOTAsImV4cCI6MjA1OTg4NjM5MH0.9e9w5iJZb50zR1hBONo4LLOO5q9-KkHhWX1DOvTsr6s',
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductCubit(Supabase.instance.client),
        ),
      ],
      // This is the root widget of your application.
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dr Mazag',
          home: const Splash(),
        );
      },
    );
  }
}
