import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/edit_brand/responsive_screen/edit_brand_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/edit_brand/responsive_screen/edit_brand_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/edit_brand/responsive_screen/edit_brand_tabllet.dart';

class EditBrandScreen extends StatelessWidget {
  const EditBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Get.arguments;
    return TSiteTemplate(
      desktop: EditBrandDesktopScreen(brand: brand),
      tablet: EditBrandTablletScreen(brand: brand),
      mobile: EditBrandMobileScreen(brand: brand),
    );
  }
}
