import 'dart:developer';

import 'package:dr_mazage_coffee/services/db_.dart';

class UserRepo {
  final DatabaseHelper databaseHelper;

  UserRepo(this.databaseHelper);

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    try {
      final user = await databaseHelper.login(username, password);

      if (user == null) return null;
      if (!user.containsKey('role')) {
        throw Exception("بيانات المستخدم غير مكتملة");
      }

      return user;
    } catch (e) {
      log("خطأ في المستودع: ${e.toString()}");
      rethrow;
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    try {
      final userId = await databaseHelper.insertUser(user);
      return userId;
    } catch (e) {
      log("خطأ في إدخال المستخدم: ${e.toString()}");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final users = await databaseHelper.getAllUsers();
      return users;
    } catch (e) {
      log("خطأ في جلب المستخدمين: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> updateAdminPassword(String newPassword, int id) async {
    try {
      await databaseHelper.updateAdminPassword(newPassword, id);
    } catch (e) {
      log("خطأ في تحديث كلمة المرور: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await databaseHelper.deleteUser(id);
    } catch (e) {
      log("خطأ في حذف المستخدم: ${e.toString()}");
      rethrow;
    }
  }
}
