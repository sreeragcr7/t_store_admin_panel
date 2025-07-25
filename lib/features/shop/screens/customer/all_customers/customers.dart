import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/customers_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/customers_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/customers_tablet.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: CustomersDesktopScreen(),
      tablet: CustomersTabletScreen(),
      mobile: CustomersMobileScreen(),
    );
  }
}
