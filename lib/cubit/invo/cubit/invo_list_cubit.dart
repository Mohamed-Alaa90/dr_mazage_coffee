import 'package:dr_mazage_coffee/models/invoice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_mazage_coffee/repository/invoice_repo.dart';

class InvoicesListCubit extends Cubit<List<Invoice>> {
  final InvoiceRepository _repository;

  InvoicesListCubit(this._repository) : super([]);

  Future<void> loadInvoices() async {
    try {
      emit([]); // إظهار حالة التحميل
      final invoices = await _repository.getAllInvoices();
      emit(invoices);
    } catch (e) {
      if (kDebugMode) {
        print('خطأ في تحميل الفواتير: $e');
      }
      emit([]);
    }
  }
}
