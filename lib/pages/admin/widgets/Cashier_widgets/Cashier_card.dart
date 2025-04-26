import 'package:dr_mazage_coffee/cubit/user/auth_cubit.dart';
import 'package:dr_mazage_coffee/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dr_mazage_coffee/widgets/my_button.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          children: [
            _UserCardHeader(user: user),
            const Divider(),
            _UserDetailsButton(user: user),
          ],
        ),
      ),
    );
  }
}

class _UserCardHeader extends StatelessWidget {
  final Map<String, dynamic> user;

  const _UserCardHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _UserAvatar(username: user['username']),
        SizedBox(width: 12.w),
        _UserInfo(username: user['username'], role: user['role']),
        const Spacer(),
        _ActionButtons(user: user),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String? username;

  const _UserAvatar({this.username});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22.r,
      backgroundColor: Colors.brown.shade200,
      child: Text(
        (username != null && username.toString().isNotEmpty)
            ? username.toString().substring(0, 1).toUpperCase()
            : '?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final String? username;
  final String? role;

  const _UserInfo({this.username, this.role});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username ?? 'غير معروف',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
        ),
        Text(
          'الصلاحية: ${role ?? '---'}',
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Map<String, dynamic> user;

  const _ActionButtons({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => _showDeleteDialog(context, user),
          icon: const Icon(Icons.delete),
        ),
        IconButton(
          onPressed: () => _showEditDialog(context, user),
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المستخدم'),
        content: const Text('هل أنت متأكد من حذف هذا المستخدم؟'),
        actions: [
          MyCustomButton(
            text: 'حذف',
            onPressed: () {
              context.read<AuthCubit>().deleteUser(user['id']);
              context.read<AuthCubit>().getAllUsers();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المستخدم')),
              );
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> user) {
    final editController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل المستخدم'),
        content: MyTextField(
          controller: editController,
          libelText: 'كلمة المرور الجديدة',
          keyboardType: TextInputType.text,
        ),
        actions: [
          MyCustomButton(
            text: 'تعديل',
            onPressed: () {
              _handlePasswordUpdate(context, editController.text.trim(), user);
            },
            color: Colors.brown,
          ),
        ],
      ),
    );
  }

  void _handlePasswordUpdate(
      BuildContext context, String newPassword, Map<String, dynamic> user) {
    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال كلمة مرور جديدة')),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل')),
      );
      return;
    }

    context.read<AuthCubit>().updateAdminPassword(newPassword, user['id']);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تعديل كلمة المرور')),
    );
    context.read<AuthCubit>().getAllUsers();
  }
}

class _UserDetailsButton extends StatelessWidget {
  final Map<String, dynamic> user;

  const _UserDetailsButton({required this.user});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showUserDetailsDialog(context, user),
      child: const Text('عرض التفاصيل'),
    );
  }

  void _showUserDetailsDialog(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل المستخدم'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('👤 اسم المستخدم: ${user['username']}'),
            Text('🔑 الباسورد: ${user['password']}'),
            Text('🛡️ الصلاحية: ${user['role']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
