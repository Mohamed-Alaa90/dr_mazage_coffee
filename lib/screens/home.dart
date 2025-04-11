import 'package:dr_mazage_coffee/cubit/product/product_cubit.dart';
import 'package:dr_mazage_coffee/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final categories = [
    {'name': 'بن', 'color': Color(0XFFaf8d66), 'image': 'assets/beans.png'},
    {'name': 'شاي', 'color': Color(0XFF51744d), 'image': 'assets/tea.png'},
    {
      'name': 'نسكافيه',
      'color': Color(0XFF34404c),
      'image': 'assets/nescafe.png',
    },
    {'name': 'قهوه', 'color': Color(0XFF845330), 'image': 'assets/coffee.png'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2e7db),
      appBar: AppBar(
        title: const Text(
          'Dr Mazag Coffee',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xfff2e7db),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16.0,
                    runSpacing: 16.0,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      for (int i = 0; i < categories.length; i++)
                        _buildProductCard(
                          categories[i]['color']! as Color,
                          categories[i]['name']! as String,
                          categories[i]['image']! as String,
                          i,
                          () {
                            // Handle tap event
                            Get.to(
                              () => BlocProvider(
                                create:
                                    (context) => ProductCubit(
                                      Supabase.instance.client,
                                    )..fetchProducts(
                                      type: categories[i]['name']! as String,
                                    ),
                                child: ProductScreen(
                                  categoryColor:
                                      categories[i]['color'] as Color,
                                  categoryImage:
                                      categories[i]['image'] as String,
                                  categoryName:
                                      categories[i]['name']! as String,
                                ),
                              ),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 0XFF1b0a12
  Widget _buildProductCard(
    Color color,
    String name,
    String image,
    int index,
    VoidCallback? onTap,
  ) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform:
                Matrix4.identity()..translate(0.0, isHovered ? -5.0 : 0.0),
            child: Card(
              elevation: isHovered ? 8.0 : 4.0,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onTap: onTap,
                child: Container(
                  width: 40.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(image, width: 40.w, height: 40.h),
                      SizedBox(height: 4.h),
                      Text(
                        name,
                        style: TextStyle(color: Colors.white, fontSize: 6.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
