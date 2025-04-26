import 'package:dr_mazage_coffee/cubit/invo/cubit/invoice_cubit.dart';
import 'package:dr_mazage_coffee/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String category;
  final Color color;
  final String image;

  const ProductCard({
    super.key,
    required this.product,
    required this.category,
    required this.color,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleProductTap(context),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Colors.brown.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(image, width: 80, height: 80),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'السعر: ${product.price} جنيه',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                'المخزون: ${product.quantity} ${product.unit}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => _handleProductTap(context),
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.white,
                  size: 28,
                ),
                tooltip: 'أضف المنتج',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleProductTap(BuildContext context) {
    if (product.name.contains('بن')) {
      context.read<InvoiceCubit>().addProductWithQuantity(product);
    } else {
      context.read<InvoiceCubit>().addProduct(product);
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة ${product.name} إلى الفاتورة',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
}
