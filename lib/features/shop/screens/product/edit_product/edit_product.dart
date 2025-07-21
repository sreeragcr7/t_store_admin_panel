import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/edit_product/responsive_screens/edit_product_dektop.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/edit_product/responsive_screens/edit_product_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/edit_product/responsive_screens/edit_product_tablet.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: EditProductDektopScreen(),
      tablet: EditProductTabletScreen(),
      mobile: EditProductMobileScreen(),
    );
  }
}
