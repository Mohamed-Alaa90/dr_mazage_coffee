// lib/cubits/product/product_state.dart
// Removed import as per the part-of directive requirement
import 'package:dr_mazage_coffee/models/product.dart'; // Ensure this path is correct

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  ProductsLoaded(this.products);
}

class ProductAdded extends ProductState {}

class ProductUpdated extends ProductState {}

class ProductDeleted extends ProductState {}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}