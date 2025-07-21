import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/all_product/responsive_screens/product_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/all_product/responsive_screens/product_mobile.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: ProductDesktopScreen(),
      tablet: ProductDesktopScreen(),
      mobile: ProductMobileScreen(),
    );
  }
}
