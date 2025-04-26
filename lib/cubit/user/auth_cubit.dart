import 'dart:developer';

import 'package:dr_mazage_coffee/cubit/user/auth_state.dart';
import 'package:dr_mazage_coffee/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepo userRepo;
  AuthCubit(this.userRepo) : super(AuthInitial());

  Future<void> login(String userName, String password) async {
    emit(AuthLoading());

    try {
      final user = await userRepo.loginUser(userName, password);

      final role = user?['role'] as String?;
      if (role == 'admin') {
        emit(const AuthAuthenticated('admin'));
      } else if (role == 'user') {
        emit(const AuthAuthenticated('user'));
      } else {
        emit(const AuthError("لم يتم العثور على نوع المستخدم"));
      }
    } catch (e) {
      emit(AuthError("حدث خطأ: ${e.toString()}"));
      log(e.toString());
    }
  }

  Future<void> addUser(Map<String, dynamic> user) async {
    emit(AuthLoading());

    try {
      final userId = await userRepo.insertUser(user);
      emit(UserAdded(userId));
    } catch (e) {
      emit(AuthError("حدث خطأ: ${e.toString()}"));
      log(e.toString());
    }
  }

  Future<void> getAllUsers() async {
    emit(AuthLoading());

    try {
      final users = await userRepo.getAllUsers();
      emit(AuthAuthenticated('admin', users: users)); // تمرير المستخدمين هنا
    } catch (e) {
      emit(AuthError("حدث خطأ: ${e.toString()}"));
      log(e.toString());
    }
  }

  Future<void> updateAdminPassword(String newPassword, int id) async {
    emit(AuthLoading());

    try {
      await userRepo.updateAdminPassword(newPassword, id);
      emit(const AdminPasswordUpdated());
    } catch (e) {
      emit(AuthError("حدث خطأ: ${e.toString()}"));
      log(e.toString());
    }
  }

  Future<void> deleteUser(int id) async {
    emit(AuthLoading());

    try {
      await userRepo.deleteUser(id);
      emit(const AuthAuthenticated('admin'));
    } catch (e) {
      emit(AuthError("حدث خطأ: ${e.toString()}"));
      log(e.toString());
    }
  }

  void logout() {
    emit(AuthInitial());
  }
}
