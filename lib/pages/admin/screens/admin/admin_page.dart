import 'package:dr_mazage_coffee/pages/admin/widgets/admin_widgets/admin_main_content.dart';
import 'package:dr_mazage_coffee/pages/admin/widgets/admin_widgets/admin_sidebar.dart';
import 'package:dr_mazage_coffee/pages/admin/widgets/menu_items.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  AdminPage({super.key});

  final menuController = MenuItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(menuController: menuController),
          Expanded(
            flex: 4,
            child: AdminMainContent(menuController: menuController),
          ),
        ],
      ),
    );
  }
}
