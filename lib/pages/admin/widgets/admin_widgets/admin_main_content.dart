import 'package:dr_mazage_coffee/pages/admin/screens/product/add_product_page.dart';
import 'package:dr_mazage_coffee/pages/admin/widgets/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminMainContent extends StatelessWidget {
  final MenuItems menuController;

  const AdminMainContent({super.key, required this.menuController});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0XFFf0eee8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('مرحباً بك في لوحة التحكم', style: TextStyle(fontSize: 28.sp)),
            SizedBox(height: 70.h),
            Text('ضيف منتجاتك', style: TextStyle(fontSize: 28.sp)),
            SizedBox(height: 30.h),
            Card(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => AddProductPage(),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Icon(Icons.add, size: 70.sp),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
