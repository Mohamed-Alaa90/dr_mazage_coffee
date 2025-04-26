import 'package:dr_mazage_coffee/cubit/user/auth_cubit.dart';
import 'package:dr_mazage_coffee/cubit/user/auth_state.dart';
import 'package:dr_mazage_coffee/pages/admin/screens/admin/admin_page.dart';
import 'package:dr_mazage_coffee/pages/cashier/screens/cashier_page.dart';
import 'package:dr_mazage_coffee/widgets/my_button.dart';
import 'package:dr_mazage_coffee/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late double fieldWidth;

  @override
  Widget build(BuildContext context) {
    fieldWidth = MediaQuery.of(context).size.width * 0.3;

    return Form(
      key: formKey,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => WillPopScope(
                onWillPop: () async => false,
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.brown,
                    size: 50.0,
                  ),
                ),
              ),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.of(context, rootNavigator: true).pop();

            if (state.role == 'admin') {
              Get.offAll(
                () => AdminPage(),
                duration: const Duration(milliseconds: 500),
              );
            } else if (state.role == 'user') {
              Get.offAll(
                () => const CashierPage(),
                duration: const Duration(milliseconds: 500),
              );
            }
          } else if (state is AuthError) {
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Card(
              color: const Color(0XFFf0eee8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(60.0.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: fieldWidth,
                      child: MyTextField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك أدخل  اسم المستخدم';
                          }

                          return null;
                        },
                        controller: emailController,
                        libelText: 'اسم المستخدم',
                        icon: Icons.email,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: fieldWidth,
                      child: MyTextField(
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك أدخل كلمة المرور';
                          }

                          return null;
                        },
                        controller: passwordController,
                        libelText: 'كلمة المرور',
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: fieldWidth * 0.8, // نسبة من عرض الحقل
                      height: 70.h,
                      child: MyCustomButton(
                        isLoading: state is AuthLoading,
                        color: Colors.brown,
                        text: 'تسجيل الدخول',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context).login(
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
