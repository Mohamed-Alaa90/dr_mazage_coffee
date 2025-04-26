import 'dart:developer';

import 'package:dr_mazage_coffee/cubit/product/cubit/product_cubit.dart';
import 'package:dr_mazage_coffee/cubit/product/cubit/product_state.dart';
import 'package:dr_mazage_coffee/models/product.dart';
import 'package:dr_mazage_coffee/widgets/my_button.dart';
import 'package:dr_mazage_coffee/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({
    super.key,
    required this.nameController,
    required this.categoryController,
    required this.priceController,
    required this.quantityController,
  });

  final TextEditingController nameController;
  final TextEditingController categoryController;
  final TextEditingController priceController;
  final TextEditingController quantityController;

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _categories = ['قهوة', 'شاي', 'نسكافيه', 'اندومي', 'بن'];
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 40.h),
          MyTextField(
            keyboardType: TextInputType.text,
            controller: widget.nameController,
            libelText: 'اسم المنتج',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يجب إدخال اسم المنتج';
              }
              return null;
            },
          ),
          SizedBox(height: 40.h),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'فئة المنتج',
              border: OutlineInputBorder(),
            ),
            items: _categories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) => setState(() {
              _selectedCategory = value;
            }),
            validator: (value) {
              if (value == null) {
                return 'يجب اختيار الفئة';
              }
              return null;
            },
          ),
          SizedBox(height: 40.h),
          MyTextField(
            controller: widget.priceController,
            libelText: 'سعر المنتج',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يجب إدخال السعر';
              }
              if (double.tryParse(value) == null) {
                return 'قيمة غير صالحة';
              }
              return null;
            },
          ),
          SizedBox(height: 40.h),
          MyTextField(
            controller: widget.quantityController,
            libelText: 'كمية المنتج',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يجب إدخال الكمية';
              }
              if (int.tryParse(value) == null) {
                return 'قيمة غير صالحة';
              }
              return null;
            },
          ),
          SizedBox(height: 60.h),
          BlocConsumer<ProductCubit, ProductState>(
            listener: (context, state) {
              if (state is ProductAdded) {
                Get.snackbar('نجاح', 'تمت إضافة المنتج بنجاح',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white);
              } else if (state is ProductLoading) {
                Get.snackbar('تحميل', 'جاري تحميل البيانات...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue,
                    colorText: Colors.white);
              } else if (state is ProductError) {
                Get.snackbar('خطأ', state.message,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
              }
            },
            builder: (context, state) {
              return MyCustomButton(
                text: 'اضافه المنتج',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final double? price =
                        double.tryParse(widget.priceController.text);
                    final int? quantity =
                        int.tryParse(widget.quantityController.text);

                    if (price == null || quantity == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('يرجى إدخال قيم رقمية صحيحة')),
                      );
                      return;
                    }

                    final newProduct = Product(
                      name: widget.nameController.text,
                      price: price,
                      category: _selectedCategory!,
                      quantity: quantity,
                      unit: _getUnitByCategory(_selectedCategory!),
                    );

                    context.read<ProductCubit>().addProduct(newProduct);

                    widget.nameController.clear();
                    widget.priceController.clear();
                    widget.quantityController.clear();
                    widget.categoryController.clear();
                    _selectedCategory = null;

                    log('Product added: ${newProduct.toMap()}');
                  }
                },
                color: Colors.brown,
                isLoading: state is ProductLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  String _getUnitByCategory(String category) {
    switch (category) {
      case 'قهوة':
        return 'كوبايه';
      case 'بن':
        return 'جرام';
      case 'شاي':
        return 'كوباية';
      case 'نسكافيه':
        return 'كوباية';
      case 'اندومي':
        return 'طبق';
      default:
        return 'وحدة';
    }
  }
}
