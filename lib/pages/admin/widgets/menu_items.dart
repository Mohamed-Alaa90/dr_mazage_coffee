import 'package:dr_mazage_coffee/models/menu_details.dart';
import 'package:dr_mazage_coffee/pages/admin/screens/Cashier/add_Cashier_by_admin.dart';
import 'package:dr_mazage_coffee/pages/admin/screens/Cashier/all_Cashier_screen.dart';
import 'package:dr_mazage_coffee/pages/admin/screens/invo_page.dart';
import 'package:dr_mazage_coffee/pages/admin/screens/product/product_page.dart';
import 'package:flutter/material.dart';

class MenuItems {
  final List<MenuDetails> items = [
    const MenuDetails(
      icon: Icons.shopping_cart,
      name: 'المنتجات',
      page: ProductPage(),
    ),
     MenuDetails(
      icon: Icons.receipt,
      name: 'الفواتير',
      page: AdminInvoicesPage(),
    ),
    const MenuDetails(
      icon: Icons.settings,
      name: 'اضافه كاشير',
      page: AddCashierByAdmin(),
    ),
    const MenuDetails(
      icon: Icons.people,
      name: 'كل المستخدمين',
      page: AllCashierScreen(),
    ),
  ];
}
