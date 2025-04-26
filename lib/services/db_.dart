import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // أسماء الجداول والأعمدة
  static const String tableProducts = 'products';
  static const String tableInvoices = 'invoices';
  static const String tableInvoiceItems = 'invoice_items';
  static const String tableUsers = 'users';

  // أعمدة جدول المنتجات
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnPrice = 'price';
  static const String columnCategory = 'category';
  static const String columnQuantity = 'quantity';
  static const String columnUnit = 'unit';

  // أعمدة جدول الفواتير
  static const String columnInvoiceId = 'invoice_id';
  static const String columnTotal = 'total';
  static const String columnDateTime = 'date_time';
  static const String columnCashierName = 'cashier_name';
  static const String columnProductName = 'product_name';

  // أعمدة جدول عناصر الفاتورة
  static const String columnItemId = 'item_id';
  static const String columnProductId = 'product_id';
  static const String columnQuantitySold = 'quantity_sold';
  static const String columnTotalPrice = 'total_price';
  static const String columnUnitSold = 'unit_sold';

  // أعمدة جدول المستخدمين
  static const String columnUsername = 'username';
  static const String columnPassword = 'password';
  static const String columnRole = 'role';

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'coffee_shop.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createUsersTable(db);
    await _createProductsTable(db);
    await _createInvoicesTable(db);
    await _createInvoiceItemsTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE $tableInvoiceItems 
        ADD COLUMN $columnUnitSold TEXT NOT NULL DEFAULT 'g'
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE $tableInvoices 
        ADD COLUMN $columnProductName TEXT NOT NULL DEFAULT ''
      ''');
    }
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUsername TEXT NOT NULL,
        $columnPassword TEXT NOT NULL,
        $columnRole TEXT NOT NULL
      )
    ''');
    await db.insert(tableUsers, {
      columnUsername: 'admin',
      columnPassword: 'admin123',
      columnRole: 'admin',
    });
  }

  Future<void> _createProductsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableProducts (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnPrice REAL NOT NULL DEFAULT 0.0,
        $columnCategory TEXT NOT NULL,
        $columnQuantity INTEGER NOT NULL DEFAULT 0,
        $columnUnit TEXT NOT NULL,
        UNIQUE($columnName)
    ''');
  }

  Future<void> _createInvoicesTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableInvoices (
        $columnInvoiceId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTotal REAL NOT NULL,
        $columnDateTime TEXT NOT NULL,
        $columnCashierName TEXT NOT NULL,
        $columnProductName TEXT NOT NULL DEFAULT ''
      )
    ''');
  }

  Future<void> _createInvoiceItemsTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableInvoiceItems (
        $columnItemId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnInvoiceId INTEGER NOT NULL,
        $columnProductId INTEGER NOT NULL,
        $columnQuantitySold INTEGER NOT NULL,
        $columnTotalPrice REAL NOT NULL,
        $columnUnitSold TEXT NOT NULL,
        FOREIGN KEY ($columnInvoiceId) REFERENCES $tableInvoices($columnInvoiceId),
        FOREIGN KEY ($columnProductId) REFERENCES $tableProducts($columnId)
      )
    ''');
  }

  // region Invoices
  Future<int> createInvoice(Map<String, dynamic> invoice) async {
    final db = await database;
    return await db.insert(tableInvoices, {
      columnTotal: invoice['total'],
      columnDateTime: invoice['date_time'],
      columnCashierName: invoice['cashier_name'],
      columnProductName: invoice['product_name'] ?? '',
    });
  }

  Future<List<Map<String, dynamic>>> getAllInvoices() async {
    final db = await database;
    return await db.query(tableInvoices, orderBy: '$columnDateTime DESC');
  }

  Future<int> addInvoiceItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert(tableInvoiceItems, {
      columnInvoiceId: item['invoice_id'],
      columnProductId: item['product_id'],
      columnQuantitySold: item['quantity_sold'],
      columnTotalPrice: item['total_price'],
      columnUnitSold: item['unit_sold'] ?? 'g',
    });
  }

  Future<List<Map<String, dynamic>>> getInvoiceItems(int invoiceId) async {
    final db = await database;
    return await db.query(
      tableInvoiceItems,
      where: '$columnInvoiceId = ?',
      whereArgs: [invoiceId],
    );
  }

  Future<Map<String, dynamic>> getInvoiceWithDetails(int invoiceId) async {
    final db = await database;
    final invoice = await db.query(
      tableInvoices,
      where: '$columnInvoiceId = ?',
      whereArgs: [invoiceId],
    );

    final items = await db.rawQuery('''
      SELECT 
        p.$columnName, 
        i.$columnQuantitySold, 
        p.$columnPrice, 
        i.$columnTotalPrice,
        i.$columnUnitSold
      FROM $tableInvoiceItems i
      INNER JOIN $tableProducts p ON i.$columnProductId = p.$columnId
      WHERE i.$columnInvoiceId = ?
    ''', [invoiceId]);

    return {
      'invoice': invoice.first,
      'items': items,
    };
  }
  // endregion

  // region Products
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert(tableProducts, product);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query(tableProducts);
  }

  Future<int> updateProduct(int id, Map<String, dynamic> updates) async {
    final db = await database;
    return await db.update(tableProducts, updates,
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db
        .delete(tableProducts, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getProductById(int productId) async {
    final db = await database;
    final result = await db.query(
      tableProducts,
      where: '$columnId = ?',
      whereArgs: [productId],
      limit: 1,
    );
    return result.first;
  }
  // endregion

  // region Users
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(tableUsers, user);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query(tableUsers);
  }

  Future<void> updateAdminPassword(String newPassword, int id) async {
    final db = await database;
    await db.update(
      tableUsers,
      {columnPassword: newPassword},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await database;
    return db.query(table);
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(tableUsers, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      tableUsers,
      where: '$columnUsername = ? AND $columnPassword = ?',
      whereArgs: [username, password],
    );
    if (kDebugMode) print('🔍 login result: $results');
    return results.isNotEmpty ? results.first : null;
  }
  // endregion

  Future<void> resetDatabase() async {
    final db = await database;
    await db.delete(tableProducts);
    await db.delete(tableInvoices);
    await db.delete(tableInvoiceItems);
  }

  Future<void> debugPrintTables() async {
    final db = await database;
    final tables =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    for (var table in tables) {
      final tableName = table['name'];
      final columns = await db.rawQuery('PRAGMA table_info($tableName)');
      debugPrint('Table: $tableName');
      for (var column in columns) {
        debugPrint(
            '  Column: ${column['name']}, Type: ${column['type']}, Default: ${column['dflt_value']}');
      }
    }
  }
}