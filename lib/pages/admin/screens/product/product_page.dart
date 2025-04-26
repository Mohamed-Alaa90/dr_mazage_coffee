import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_mazage_coffee/models/product.dart';
import 'package:dr_mazage_coffee/cubit/product/cubit/product_cubit.dart';
import 'package:dr_mazage_coffee/cubit/product/cubit/product_state.dart';
import 'package:dr_mazage_coffee/widgets/my_button.dart';
import 'package:dr_mazage_coffee/widgets/my_text_field.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المنتجات"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            final allProducts = state.products;
            final categories = _getCategories(allProducts);
            final filteredProducts = _getFilteredProducts(allProducts);

            return Column(
              children: [
                const SizedBox(height: 16),
                _buildCategorySelector(categories),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(child: Text("اختر فئة لعرض المنتجات"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return _buildProductCard(product);
                          },
                        ),
                ),
              ],
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("No data found."));
        },
      ),
    );
  }

  List<String> _getCategories(List<Product> products) {
    return products.map((e) => e.category).toSet().take(5).toList();
  }

  List<Product> _getFilteredProducts(List<Product> allProducts) {
    return selectedCategory == null
        ? []
        : allProducts
            .where((product) => product.category == selectedCategory)
            .toList();
  }

  Widget _buildCategorySelector(List<String> categories) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.brown : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.brown,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      // ignore: deprecated_member_use
      shadowColor: Colors.brown.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name.isEmpty ? 'غير محدد' : product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              product.price == 0 ? 'غير محدد' : 'السعر: ${product.price} جنيه',
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              product.quantity == 0
                  ? 'غير محدد'
                  : 'الكمية: ${product.quantity} ${product.unit}',
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              product.category.isEmpty
                  ? 'غير محددة'
                  : 'الفئة: ${product.category}',
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),

            //const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.brown),
                  onPressed: () => _showEditDialog(product),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProduct(product),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Product product) {
    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.price.toString());
    final quantityController =
        TextEditingController(text: product.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل المنتج'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextField(
                  controller: nameController,
                  libelText: 'اسم المنتج',
                  validator: _requiredValidator,
                  keyboardType: TextInputType.text,
                  icon: Icons.edit,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: priceController,
                  libelText: 'سعر المنتج',
                  validator: _requiredValidator,
                  keyboardType: TextInputType.number,
                  icon: Icons.monetization_on,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: quantityController,
                  libelText: 'كمية المنتج',
                  validator: _requiredValidator,
                  keyboardType: TextInputType.number,
                  icon: Icons.numbers,
                ),
              ],
            ),
          ),
          actions: [
            MyCustomButton(
              text: 'حفظ',
              onPressed: () {
                final updatedProduct = Product(
                  id: product.id,
                  name: nameController.text,
                  price: double.tryParse(priceController.text) ?? product.price,
                  quantity:
                      int.tryParse(quantityController.text) ?? product.quantity,
                  category: product.category,
                  unit: product.unit,
                );
                context.read<ProductCubit>().updateProduct(updatedProduct);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String? _requiredValidator(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  void _deleteProduct(Product product) {
    if (product.id != null) {
      context.read<ProductCubit>().deleteProduct(product.id!);
      context.read<ProductCubit>().getAllProducts();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('تم حذف "${product.name}"'),
    ));
  }
}
