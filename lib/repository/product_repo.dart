import 'package:dr_mazage_coffee/models/product.dart';
import 'package:dr_mazage_coffee/services/db_.dart';

class ProductRepo {
  final DatabaseHelper _databaseHelper;

  ProductRepo(this._databaseHelper);

  Future<List<Product>> getAllProducts() async {
    final data = await _databaseHelper.getAllProducts();
    return data.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> addProduct(Product product) async {
    return await _databaseHelper.insertProduct(product.toMap());
  }

  Future<Product?> getProductByName(String name) async {
    final allProducts = await getAllProducts();
    try {
      return allProducts.firstWhere((product) => product.name == name);
    } catch (e) {
      return null;
    }
  }

  Future<Product?> getProductById(int id) async {
    final allProducts = await getAllProducts();
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateProduct(Product product) async {
    return await _databaseHelper.updateProduct(product.id!, product.toMap());
  }

  Future<int> deleteProduct(int id) async {
    return await _databaseHelper.deleteProduct(id);
  }
}
