import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/all_brand/responsive_screens/brands_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/all_brand/responsive_screens/brands_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/all_brand/responsive_screens/brands_tablet.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: BrandsDesktopScreen(),
      tablet: BrandsTabletScreen(),
      mobile: BrandsMobileScreen(),
    );
  }
}
