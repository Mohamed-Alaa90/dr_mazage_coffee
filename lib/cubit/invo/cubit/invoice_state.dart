import 'package:dr_mazage_coffee/models/Invoice.dart';

abstract class InvoiceState  {
  const InvoiceState();

  @override
  List<Object> get props => [];
}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final List<Invoice> invoices;

  const InvoiceLoaded(this.invoices);

  @override
  List<Object> get props => [invoices];
}

class InvoiceError extends InvoiceState {
  final String message;

  const InvoiceError(this.message);

  @override
  List<Object> get props => [message];
}
