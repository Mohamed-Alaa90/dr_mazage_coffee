class InvoiceItem {
  final int? id;
  final int? invoiceId;
  final int productId;
  final String productName;
  final int quantitySold;
  final double totalPrice;
  final String unit;

  InvoiceItem({
    this.id,
    this.invoiceId,
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.totalPrice,
    required this.unit,
  });

  InvoiceItem copyWith({
    int? id,
    int? invoiceId,
    int? productId,
    String? productName,
    int? quantitySold,
    double? totalPrice,
    String? unit,
  }) {
    return InvoiceItem(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantitySold: quantitySold ?? this.quantitySold,
      totalPrice: totalPrice ?? this.totalPrice,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'product_id': productId,
      'product_name': productName,
      'quantity_sold': quantitySold,
      'total_price': totalPrice,
      'unit': unit,
    };
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      id: map['id'] as int?,
      invoiceId: map['invoice_id'] as int?,
      productId: (map['product_id'] as int?) ?? 0,
      productName: (map['product_name'] as String?) ?? '',
      quantitySold: (map['quantity_sold'] as int?) ?? 0,
      totalPrice: (map['total_price'] as double?) ?? 0.0,
      unit: (map['unit'] as String?) ?? 'g',
    );
  }
}