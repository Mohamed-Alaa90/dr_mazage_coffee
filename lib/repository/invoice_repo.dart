import 'dart:developer';
import 'package:dr_mazage_coffee/models/invoice.dart';
import 'package:dr_mazage_coffee/models/invoice_item.dart';
import 'package:dr_mazage_coffee/services/db_.dart';

class InvoiceRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<int> saveInvoice({
    required String cashierName,
    required List<InvoiceItem> items,
    required double total,
    required String productName,
  }) async {
    try {
      final invoiceId = await dbHelper.createInvoice({
        'total': total,
        'date_time': DateTime.now().toIso8601String(),
        'cashier_name': cashierName,
        'product_name': productName,
      });

      for (final item in items) {
        await dbHelper.addInvoiceItem({
          'invoice_id': invoiceId,
          'product_id': item.productId,
          'product_name': item.productName,
          'quantity_sold': item.quantitySold,
          'total_price': item.totalPrice,
          'unit': item.unit,
        });
      }

      return invoiceId;
    } catch (e) {
      log(e.toString());
      throw Exception('فشل في حفظ الفاتورة: ${e.toString()}');
    }
  }

  Future<List<Invoice>> getAllInvoices() async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        DatabaseHelper.tableInvoices,
        orderBy: 'date_time DESC',
      );
      return result.map((map) => Invoice.fromMap(map)).toList();
    } catch (e) {
      log(e.toString());
      throw Exception('فشل في تحميل الفواتير: ${e.toString()}');
    }
  }

  Future<List<InvoiceItem>> getInvoiceItems(int invoiceId) async {
    try {
      final db = await dbHelper.database;
      final result = await db.query(
        DatabaseHelper.tableInvoiceItems,
        where: 'invoice_id = ?',
        whereArgs: [invoiceId],
      );
      return result.map((map) => InvoiceItem.fromMap(map)).toList();
    } catch (e) {
      log(e.toString());
      throw Exception('فشل في تحميل عناصر الفاتورة: ${e.toString()}');
    }
  }
}