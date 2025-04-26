import 'package:dr_mazage_coffee/main.dart';
import 'package:dr_mazage_coffee/models/Invoice_Item.dart';
import 'package:dr_mazage_coffee/models/product.dart';
import 'package:dr_mazage_coffee/repository/invoice_repo.dart';
import 'package:dr_mazage_coffee/services/db_.dart';
import 'package:dr_mazage_coffee/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceCubit extends Cubit<List<InvoiceItem>> {
  final InvoiceRepository repository;
  final DatabaseHelper dbHelper = DatabaseHelper();

  InvoiceCubit(this.repository) : super([]);

  void addProduct(Product product) {
    final index = state.indexWhere((item) => item.productId == product.id);
    if (index == -1) {
      emit([
        ...state,
        InvoiceItem(
          productId: product.id!,
          productName: product.name,
          quantitySold: 1,
          totalPrice: product.price,
          unit: product.unit,
        )
      ]);
    } else {
      final updatedList = List<InvoiceItem>.from(state);
      final currentItem = updatedList[index];
      final updatedItem = currentItem.copyWith(
        quantitySold: currentItem.quantitySold + 1,
        totalPrice: currentItem.totalPrice + product.price,
      );
      updatedList[index] = updatedItem;
      emit(updatedList);
    }
  }

  Future<void> addProductWithQuantity(Product product,
      {int? customQuantity}) async {
    if (product.name.contains('بن') && customQuantity == null) {
      final quantity = await _showGramsDialog();
      if (quantity == null || quantity <= 0) return;

      final pricePerGram = product.price / 1000;
      final totalPrice = pricePerGram * quantity;

      final index = state.indexWhere((item) => item.productId == product.id);

      if (index == -1) {
        emit([
          ...state,
          InvoiceItem(
            productId: product.id!,
            productName: product.name,
            quantitySold: quantity,
            totalPrice: totalPrice,
            unit: 'g',
          )
        ]);
      } else {
        final updatedList = List<InvoiceItem>.from(state);
        final currentItem = updatedList[index];
        final updatedItem = currentItem.copyWith(
          quantitySold: currentItem.quantitySold + quantity,
          totalPrice: currentItem.totalPrice + totalPrice,
        );
        updatedList[index] = updatedItem;
        emit(updatedList);
      }
    } else {
      addProduct(product);
    }
  }

  Future<int?> _showGramsDialog() async {
    int grams = 0;
    final context = navigatorKey.currentContext!;

    return await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('كمية البن بالجرام'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'أدخل الكمية بالجرام',
              suffixText: 'جرام',
            ),
            onChanged: (value) {
              grams = int.tryParse(value) ?? 0;
            },
          ),
          actions: [
            MyCustomButton(
              color: Colors.transparent,
              onPressed: () => Navigator.pop(context),
              text: 'إلغاء',
            ),
            MyCustomButton(
              onPressed: () => Navigator.pop(context, grams > 0 ? grams : null),
              text: 'تأكيد',
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProductQuantity(
      int productId, int quantitySold, String unit) async {
    final db = await dbHelper.database;
    final product = await db.query(
      DatabaseHelper.tableProducts,
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [productId],
    );

    if (product.isNotEmpty) {
      final currentQuantity =
          product.first[DatabaseHelper.columnQuantity] as int;
      final productUnit = product.first[DatabaseHelper.columnUnit] as String;

      int quantityToDeduct = quantitySold;

      if (unit == 'g' && productUnit == 'kg') {
        quantityToDeduct = quantitySold;
      } else if (unit == 'kg' && productUnit == 'g') {
        quantityToDeduct = quantitySold * 1000;
      }

      final newQuantity = currentQuantity - quantityToDeduct;

      if (newQuantity >= 0) {
        await db.update(
          DatabaseHelper.tableProducts,
          {DatabaseHelper.columnQuantity: newQuantity},
          where: '${DatabaseHelper.columnId} = ?',
          whereArgs: [productId],
        );
      } else {
        throw Exception('الكمية المطلوبة غير متوفرة في المخزن');
      }
    }
  }

  Future<int> confirmInvoice(String cashierName) async {
    if (state.isEmpty) {
      throw Exception('لا يمكن حفظ فاتورة فارغة');
    }

    final total = state.fold(0.0, (sum, item) => sum + item.totalPrice);
    final productNames = state.map((e) => e.productName).join(', ');

    final id = await repository.saveInvoice(
      cashierName: cashierName,
      items: state,
      total: total,
      productName: productNames,
    );

    for (final item in state) {
      await updateProductQuantity(item.productId, item.quantitySold, item.unit);
    }

    clear();
    return id;
  }

  void removeProduct(int productId) {
    final updatedList =
        state.where((item) => item.productId != productId).toList();
    emit(updatedList);
  }

  void clear() => emit([]);

  double get total => state.fold(0, (sum, item) => sum + item.totalPrice);
}
