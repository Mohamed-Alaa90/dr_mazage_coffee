import 'dart:async';
import 'dart:developer';

import 'package:dr_mazage_coffee/model/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final SupabaseClient _supabase;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;
  String? _currentType;

  ProductCubit(SupabaseClient supabase)
      : _supabase = supabase,
        super(ProductInitial());

  Future<void> fetchProducts({required String type}) async {
    if (_currentType == type && state is ProductLoaded) return;

    emit(ProductLoading());
    _currentType = type;

    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('type', type)
          .order('name');

      final products = (response as List)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();

      emit(ProductLoaded(products));
      log('✅ Fetched ${products.length} $type products');
      
      // إعادة الاشتراك مع النوع الجديد
      subscribeToRealtime(type);
    } catch (e, stackTrace) {
      log('❌ Error fetching $type products', 
          error: e, stackTrace: stackTrace);
      emit(ProductError('Failed to load $type products'));
    }
  }

  void subscribeToRealtime(String type) {
    _subscription?.cancel();

    _subscription = _supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('type', type)
        .listen((payload) {
          log('🔄 Realtime update for $type products');
          _handleRealtimeUpdate(payload);
        },
        onError: (error) {
          log('❌ Realtime error: $error');
        });
  }

  void _handleRealtimeUpdate(List<Map<String, dynamic>> payload) {
    if (state is! ProductLoaded) return;

    final currentProducts = (state as ProductLoaded).products;
    final updatedProducts = List<Product>.from(currentProducts);

    for (final change in payload) {
      final product = Product.fromJson(change);
      final index = updatedProducts.indexWhere((p) => p.id == product.id);

      if (index != -1) {
        updatedProducts[index] = product;
      } else {
        updatedProducts.add(product);
      }
    }

    emit(ProductLoaded(updatedProducts));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}