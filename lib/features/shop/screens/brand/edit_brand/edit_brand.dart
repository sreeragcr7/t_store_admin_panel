import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/edit_brand/responsive_screen/edit_brand_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/edit_brand/responsive_screen/edit_brand_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/edit_brand/responsive_screen/edit_brand_tabllet.dart';

class EditBrandScreen extends StatelessWidget {
  const EditBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: EditBrandDesktopScreen(),
      tablet: EditBrandTablletScreen(),
      mobile: EditBrandMobileScreen(),
    );
  }
}
