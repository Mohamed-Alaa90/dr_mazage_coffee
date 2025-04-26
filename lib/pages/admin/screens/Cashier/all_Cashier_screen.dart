import 'package:dr_mazage_coffee/cubit/user/auth_cubit.dart';
import 'package:dr_mazage_coffee/cubit/user/auth_state.dart';
import 'package:dr_mazage_coffee/pages/admin/widgets/Cashier_widgets/Cashier_card.dart';
import 'package:dr_mazage_coffee/pages/admin/widgets/Cashier_widgets/Cashier_status_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllCashierScreen extends StatefulWidget {
  const AllCashierScreen({super.key});
  @override
  State<AllCashierScreen> createState() => _AllCashierScreenState();
}

class _AllCashierScreenState extends State<AllCashierScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جميع المستخدمين'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthError) {
              return Center(child: Text(state.message));
            } else if (state is AuthAuthenticated) {
              final users = state.users;
              if (users == null || users.isEmpty) {
                return const StatusMessage(message: 'لا يوجد مستخدمين حالياً');
              }

              return ListView.separated(
                itemCount: users.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) => UserCard(user: users[index]),
              );
            }

            return const StatusMessage(message: 'لا توجد بيانات');
          },
        ),
      ),
    );
  }
}
