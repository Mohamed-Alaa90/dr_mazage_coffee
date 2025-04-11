import 'package:dr_mazage_coffee/cubit/product/product_cubit.dart';
import 'package:dr_mazage_coffee/widget/card_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProductScreen extends StatefulWidget {
  final String categoryName;
  final String categoryImage;
  final Color categoryColor;
  const ProductScreen({
    super.key,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryColor,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    // الاشتراك في التحديثات عند بناء الشاشة
    context.read<ProductCubit>().subscribeToRealtime(widget.categoryName);
    // تحميل المنتجات الأولية
    context.read<ProductCubit>().fetchProducts(type: widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2e7db),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.categoryName,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: widget.categoryColor,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return _buildLoading();
          } else if (state is ProductLoaded) {
            return _buildLLoaded();
          } else if (state is ProductError) {
            return _buildError(state.error);
          } else {
            return const Center(
              child: Text(
                'No products available',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: const Color(0XFFd96d16),
        size: 50,
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Text(
        'Error: $error',
        style: const TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }

  Widget _buildLLoaded() {
    final products =
        (context.read<ProductCubit>().state as ProductLoaded).products;
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return CardProduct(
          color: widget.categoryColor,
          image: widget.categoryImage,
          product: products[index],
        );
      },
    );
  }
}
