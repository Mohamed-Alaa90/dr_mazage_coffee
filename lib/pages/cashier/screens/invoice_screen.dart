import 'package:dr_mazage_coffee/cubit/invo/cubit/invoice_cubit.dart';
import 'package:dr_mazage_coffee/cubit/product/cubit/product_cubit.dart';
import 'package:dr_mazage_coffee/models/Invoice_Item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoScreen extends StatelessWidget {
  final String cashierName;

  const InvoScreen({required this.cashierName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء فاتورة جديدة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => context.read<InvoiceCubit>().clear(),
            tooltip: 'مسح الفاتورة',
          ),
        ],
      ),
      body: BlocConsumer<InvoiceCubit, List<InvoiceItem>>(
        listener: (context, state) {
          if (state.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم مسح الفاتورة')),
            );
          }
        },
        builder: (context, items) {
          final total = context.read<InvoiceCubit>().total;

          return Column(
            children: [
              _buildInvoiceSummary(total, items.length),
              Expanded(
                child: items.isEmpty
                    ? _buildEmptyState()
                    : _buildInvoiceItemsList(context, items),
              ),
              _buildCheckoutSection(context, items, total),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInvoiceSummary(double total, int itemsCount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.brown[50],
          border: Border(bottom: BorderSide(color: Colors.grey[300]!))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('عدد العناصر: $itemsCount',
              style: const TextStyle(fontSize: 16)),
          Text('الإجمالي: ${total.toStringAsFixed(2)}جنيه',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('لا توجد عناصر في الفاتورة',
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          const Text('قم بإضافة منتجات لإنشاء فاتورة',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInvoiceItemsList(BuildContext context, List<InvoiceItem> items) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key(item.productId.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) =>
              context.read<InvoiceCubit>().removeProduct(item.productId),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: Colors.brown[100],
                child: Text('${item.quantitySold}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              title: Text(item.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('${item.quantitySold} ${item.unit}',
                      style: TextStyle(color: Colors.grey[600])),
                  Text(
                      '${(item.totalPrice / item.quantitySold).toStringAsFixed(2)}  جنيه لل${item.unit}',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              trailing: Text('${item.totalPrice.toStringAsFixed(2)} جنيه',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutSection(
      BuildContext context, List<InvoiceItem> items, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save, size: 24),
              label: const Text('حفظ الفاتورة', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: items.isEmpty ? null : () => _confirmInvoice(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmInvoice(BuildContext context) async {
    try {
      final invoiceId =
          await context.read<InvoiceCubit>().confirmInvoice(cashierName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ الفاتورة #$invoiceId'),
          duration: const Duration(seconds: 2),
        ),
      );

      context.read<ProductCubit>().getAllProducts();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
