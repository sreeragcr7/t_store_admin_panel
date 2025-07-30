import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/all_orders/responsive_screens/orders_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/all_orders/responsive_screens/orders_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/all_orders/responsive_screens/orders_tablet.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(desktop: OrdersDesktopScreen(), tablet: OrdersTabletScreen(), mobile: OrdersMobileScreen());
  }
}
