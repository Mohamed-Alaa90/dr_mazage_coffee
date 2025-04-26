import 'dart:developer';
import 'package:dr_mazage_coffee/cubit/product/cubit/product_state.dart';
import 'package:dr_mazage_coffee/models/product.dart';
import 'package:dr_mazage_coffee/repository/product_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo productRepo;
  ProductCubit(this.productRepo) : super(ProductInitial());
  Future<void> getAllProducts() async {
    emit(ProductLoading());
    try {
      final products = await productRepo.getAllProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
      log('erooor ${e.toString()}');
    }
  }

  Future<void> addProduct(Product product) async {
    emit(ProductLoading());
    try {
      final existingProduct = await productRepo.getProductByName(product.name);

      if (existingProduct != null) {
        emit(ProductError('المنتج "${product.name}" موجود بالفعل'));
        return;
      }

      final result = await productRepo.addProduct(product);
      if (result > 0) {
        emit(ProductAdded());
        await getAllProducts();
      } else {
        emit(ProductError('فشل في إضافة المنتج'));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
      log('erooor ${e.toString()}');
    }
  }

  Future<void> updateProduct(Product product) async {
    emit(ProductLoading());
    try {
      await productRepo.updateProduct(product);
      emit(ProductUpdated());
      await getAllProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> deleteProduct(int id) async {
    emit(ProductLoading());
    try {
      await productRepo.deleteProduct(id);
      emit(ProductDeleted());
      await getAllProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
