class Product {
  final int id;
  final String name;
  final String price;
  final String stock;
  final String type;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.type,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      price: json['price'] as String,
      stock: json['stock'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'type': type,
    };
  }
}
