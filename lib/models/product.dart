// lib/models/product_model.dart
class Product {
  final int? id;
  final String name;
  final double price;
  final String category;
  final int quantity;
  final String unit;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.unit,
  });

  // تحويل من Map إلى Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      unit: map['unit'] ?? '',
    );
  }

  // تحويل من Product إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'quantity': quantity,
      'unit': unit,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? category,
    int? quantity,
    String? unit,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}