import 'package:dr_mazage_coffee/models/product.dart';
import 'package:dr_mazage_coffee/pages/cashier/widget/cashier_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CategoryProductsPage extends StatelessWidget {
  final String category;
  final List<Product> products;
  final Color color;
  final String image;

  const CategoryProductsPage({
    super.key,
    required this.category,
    required this.products,
    required this.color,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(category),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50.h,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AnimationLimiter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(products.length, (index) {
                    final product = products[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 700),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ProductCard(
                              image: image,
                              category: category,
                              product: product,
                              color: color,
                            ), // الكارت
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
