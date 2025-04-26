import 'package:dr_mazage_coffee/cubit/invo/cubit/invo_list_cubit.dart';
import 'package:dr_mazage_coffee/cubit/invo/cubit/invoice_cubit.dart';
import 'package:dr_mazage_coffee/cubit/product/cubit/product_cubit.dart';
import 'package:dr_mazage_coffee/cubit/user/auth_cubit.dart';
import 'package:dr_mazage_coffee/repository/invoice_repo.dart';
import 'package:dr_mazage_coffee/repository/product_repo.dart';
import 'package:dr_mazage_coffee/repository/user_repo.dart';
import 'package:dr_mazage_coffee/services/db_.dart';
import 'package:dr_mazage_coffee/src/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = DatabaseHelper();
  final productRepo = ProductRepo(database);
  final userRepo = UserRepo(database);
  final invoRepo = InvoiceRepository();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(productRepo)..getAllProducts(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(userRepo),
        ),
        BlocProvider(
          create: (context) => InvoiceCubit(invoRepo),
        ),
        BlocProvider(
          create: (context) => InvoicesListCubit(invoRepo),
        )
      ],
      child:  MyApp(),
    ),
  );
}
