import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/product_widgets/add_product_form.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة منتج جديد'),
      ),
      body: Padding(
        padding: EdgeInsets.all(60.w),
        child: SingleChildScrollView(
          child: AddProductForm(
            nameController: nameController,
            categoryController: categoryController,
            priceController: priceController,
            quantityController: quantityController,
          ),
        ),
      ),
    );
  }
}
