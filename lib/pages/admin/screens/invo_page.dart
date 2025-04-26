import 'package:dr_mazage_coffee/cubit/invo/cubit/invo_list_cubit.dart';
import 'package:dr_mazage_coffee/models/invoice.dart';
import 'package:dr_mazage_coffee/pages/admin/widgets/invoice_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AdminInvoicesPage extends StatefulWidget {
  const AdminInvoicesPage({super.key});

  @override
  State<AdminInvoicesPage> createState() => _AdminInvoicesPageState();
}

class _AdminInvoicesPageState extends State<AdminInvoicesPage> {
  @override
  void initState() {
    context.read<InvoicesListCubit>().loadInvoices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الفواتير'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<InvoicesListCubit>().loadInvoices(),
          ),
        ],
      ),
      body: BlocBuilder<InvoicesListCubit, List<Invoice>>(
        builder: (context, invoices) {
          if (invoices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد فواتير مسجلة',
                    style: TextStyle(fontSize: 18),
                  ),
                ]),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: invoices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  title: Text(
                    'فاتورة #${invoice.id}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'المنتجات: ${invoice.productName}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الكاشير: ${invoice.cashierName}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'التاريخ: ${DateFormat('yyyy/MM/dd - hh:mm a').format(invoice.dateTime)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${invoice.total.toStringAsFixed(2)} جنيه',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InvoiceDetailsPage(
                          invoiceId: invoice.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}