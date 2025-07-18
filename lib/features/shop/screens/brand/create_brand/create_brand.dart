import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/create_brand/responsive_screen/create_brand_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/create_brand/responsive_screen/create_brand_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/create_brand/responsive_screen/create_brand_tablet.dart';

class CreateBrandScreen extends StatelessWidget {
  const CreateBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: CreateBrandDesktopScreen(),
      tablet: CreateBrandTabletScreen(),
      mobile: CreateBrandMobileScreen(),
    );
  }
}
