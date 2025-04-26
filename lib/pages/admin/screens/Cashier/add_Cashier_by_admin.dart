import 'package:dr_mazage_coffee/cubit/user/auth_cubit.dart';
import 'package:dr_mazage_coffee/cubit/user/auth_state.dart';
import 'package:dr_mazage_coffee/models/users.dart';
import 'package:dr_mazage_coffee/widgets/my_button.dart';
import 'package:dr_mazage_coffee/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddCashierByAdmin extends StatefulWidget {
  const AddCashierByAdmin({super.key});

  @override
  State<AddCashierByAdmin> createState() => _AddCashierByAdminState();
}

class _AddCashierByAdminState extends State<AddCashierByAdmin> {
  final userController = TextEditingController();

  final passwordController = TextEditingController();

  final roleController = TextEditingController();

  final List<String> _role = ['admin', 'user'];

  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('إضافة مستخدم جديد'),
          centerTitle: true,
        ),
        body: Center(
          child: SizedBox(
            width: 350.w,
            height: 450.h,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'إضافة مستخدم جديد',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    isPassword: false,
                    keyboardType: TextInputType.name,
                    icon: Icons.person,
                    libelText: 'اسم المستخدم',
                    controller: userController,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      icon: Icons.lock,
                      libelText: 'كلمة المرور',
                      controller: passwordController),
                  const SizedBox(height: 20),
                  DropdownButtonFormField(
                    items: _role
                        .map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      _selectedRole = value;
                    }),
                    decoration: const InputDecoration(
                      labelText: 'اختر الدور',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'يجب اختيار الدور';
                      }
                      return null;
                    },
                    hint: const Text('اختر الدور'),
                    value: _selectedRole,
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is UserAdded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('تم إضافة المستخدم بنجاح'),
                            backgroundColor: Colors.green,
                            animation: const AlwaysStoppedAnimation(1.0),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            action: SnackBarAction(
                              label: 'إغلاق',
                              textColor: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                        );
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: Colors.red,
                            animation: const AlwaysStoppedAnimation(1.0),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            action: SnackBarAction(
                              label: 'إغلاق',
                              textColor: Colors.white,
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return MyCustomButton(
                        color: Colors.brown,
                        onPressed: () {
                          if (userController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('من فضلك أدخل جميع الحقول'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final addNewUser = User(
                            username: userController.text,
                            password: passwordController.text,
                            role: _selectedRole ?? 'user',
                          );

                          BlocProvider.of<AuthCubit>(context)
                              .addUser(addNewUser.toMap());
                          userController.clear();
                          passwordController.clear();
                          roleController.clear();
                        },
                        text: 'إضافة مستخدم',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
