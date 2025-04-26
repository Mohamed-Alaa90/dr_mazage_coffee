class Invoice {
  final int id;
  final double total;
  final DateTime dateTime;
  final String cashierName;
  final String productName;

  Invoice({
    required this.id,
    required this.total,
    required this.dateTime,
    required this.cashierName,
    required this.productName,
  });

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] ?? map['invoice_id'] ?? 0,
      total: (map['total'] ?? 0.0).toDouble(),
      dateTime: map['date_time'] != null
          ? DateTime.parse(map['date_time'])
          : DateTime.now(),
      cashierName: map['cashier_name']?.toString() ?? '',
      productName: map['product_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'date_time': dateTime.toIso8601String(),
      'cashier_name': cashierName,
      'product_name': productName,
    };
  }
}
