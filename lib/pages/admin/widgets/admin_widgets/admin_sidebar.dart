import 'package:dr_mazage_coffee/cubit/user/auth_cubit.dart';
import 'package:dr_mazage_coffee/pages/admin/widgets/menu_items.dart';
import 'package:dr_mazage_coffee/pages/login/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminSidebar extends StatelessWidget {
  final MenuItems menuController;

  const AdminSidebar({super.key, required this.menuController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.brown,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            children: [
              Text(
                'Dr Mazage',
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
              SizedBox(height: 30.h),
              const Divider(color: Colors.white, thickness: 1),
              ...menuController.items.map(
                (item) => _buildMenuIcon(item.icon, item.name, () {
                  Get.to(() => item.page, transition: Transition.leftToRight);
                }),
              ),
              const Spacer(),
              MaterialButton(
                color: const Color(0XFFf0eee8),
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  Get.offAll(
                    () => const LoginPage(),
                    transition: Transition.leftToRight,
                  );
                },
                child: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: Color(0XFF3b2a2a)),
                ),
              ),
              const Divider(color: Colors.white, thickness: 1),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text('Version 1.0',
                    style: TextStyle(color: Colors.white, fontSize: 12.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuIcon(IconData icon, String label, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24.sp),
            SizedBox(width: 25.w),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
          ],
        ),
      ),
    );
  }
}
