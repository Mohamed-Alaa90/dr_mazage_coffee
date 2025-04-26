import 'package:dr_mazage_coffee/services/db_.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceDetailsPage extends StatelessWidget {
  final int invoiceId;

  const InvoiceDetailsPage({required this.invoiceId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الفاتورة #$invoiceId'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: DatabaseHelper().getInvoiceWithDetails(invoiceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (!snapshot.hasData || (snapshot.data!['items'] as List).isEmpty) {
            return const Center(child: Text('لا توجد بيانات متاحة'));
          }

          final invoice = snapshot.data!['invoice'] as Map<String, dynamic>;
          final items = snapshot.data!['items'] as List<Map<String, dynamic>>;

          return Column(
            children: [
              _buildInvoiceHeader(invoice),
              Expanded(child: _buildProductsList(items)),
              _buildInvoiceFooter(invoice['total']),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInvoiceHeader(Map<String, dynamic> invoice) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('رقم الفاتورة:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('#${invoice['invoice_id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('التاريخ:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(DateFormat('yyyy/MM/dd - hh:mm a')
                    .format(DateTime.parse(invoice['date_time']))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الكاشير:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(invoice['cashier_name']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(List<Map<String, dynamic>> items) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.shopping_basket, color: Colors.brown),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${item['quantity_sold']} ${item['unit_sold']}',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        '${(item['total_price'] / item['quantity_sold']).toStringAsFixed(2)} جنيه',
                        style: TextStyle(color: Colors.grey[600])),
                    Text('${item['total_price'].toStringAsFixed(2)} جنيه',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvoiceFooter(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('الإجمالي:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('${total.toStringAsFixed(2)} جنيه',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
        ],
      ),
    );
  }
}
