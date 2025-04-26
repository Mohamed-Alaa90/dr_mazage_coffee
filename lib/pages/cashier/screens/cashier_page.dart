import 'package:dr_mazage_coffee/cubit/product/cubit/product_cubit.dart';
import 'package:dr_mazage_coffee/cubit/product/cubit/product_state.dart';
import 'package:dr_mazage_coffee/cubit/user/auth_cubit.dart';
import 'package:dr_mazage_coffee/cubit/user/auth_state.dart';
import 'package:dr_mazage_coffee/models/category.dart';
import 'package:dr_mazage_coffee/models/product.dart';
import 'package:dr_mazage_coffee/pages/cashier/screens/category_products_page.dart';
import 'package:dr_mazage_coffee/pages/cashier/screens/invoice_screen.dart';
import 'package:dr_mazage_coffee/pages/login/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getAllProducts();
  }

  final List<Category> categories = [
    Category(name: ' بن', image: 'assets/beans.png', color: Colors.brown),
    Category(name: ' شاي', image: 'assets/tea.png', color: Colors.blue),
    Category(name: 'اندومي', image: 'assets/indome.png', color: Colors.pink),
    Category(name: 'قهوة', image: 'assets/coffee.png', color: Colors.orange),
    Category(name: 'نسكافيه', image: 'assets/nescafe.png', color: Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            return _buildCategoryCards(state.products);
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('حدث خطأ غير متوقع'));
        },
      ),
    );
  }

  Widget _buildCategoryCards(List<Product> products) {
    return Center(
      child: AnimationLimiter(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: categories.map((category) {
              final categoryProducts = products
                  .where((p) => p.category.trim() == category.name.trim())
                  .toList();

              return AnimationConfiguration.staggeredList(
                position: categories.indexOf(category),
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildCategoryCard(category, categoryProducts),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category, List<Product> categoryProducts) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(() => CategoryProductsPage(
                color: category.color,
                image: category.image,
                category: category.name,
                products: categoryProducts,
              ));
        },
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: category.color.withOpacity(0.8),
          shadowColor: category.color.withOpacity(0.5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(category.image, height: 50),
                SizedBox(height: 5.h),
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('كاشير'),
      actions: [
        _buildShoppingBagButton(context),
        _buildLogoutButton(context),
      ],
    );
  }

  IconButton _buildShoppingBagButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        final authState = context.read<AuthCubit>().state;
        if (authState is AuthAuthenticated) {
          final cashierName = authState.role ?? 'غير معروف';
          Get.to(() => InvoScreen(cashierName: cashierName));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لم يتم تسجيل الدخول')),
          );
        }
      },
      icon: const Icon(
        Icons.shopping_bag_rounded,
        color: Colors.white,
      ),
    );
  }

  IconButton _buildLogoutButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'تسجيل الخروج',
      color: Colors.white,
      onPressed: () => _showLogoutDialog(context),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد تسجيل الخروج'),
          content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء', style: TextStyle(color: Colors.brown)),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).logout();
                Get.offAll(() => const LoginPage());
              },
              child: const Text('تسجيل الخروج',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
