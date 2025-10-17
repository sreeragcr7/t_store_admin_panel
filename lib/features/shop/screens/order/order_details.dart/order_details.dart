import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/order_details.dart/responsive_screens/order_details_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/order_details.dart/responsive_screens/order_details_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/order_details.dart/responsive_screens/order_details_tablet.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;
    final orderId = Get.parameters['orderId'];
    return TSiteTemplate(
      desktop: OrderDetailsDesktopScreen(order: order),
      tablet: OrderDetailsTabletScreen(order: order),
      mobile: OrderDetailsMobileScreen(order: order),
    );
  }
}
