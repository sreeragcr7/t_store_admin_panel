import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/all_banner/responsive_screens/banners_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/all_banner/responsive_screens/banners_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/all_banner/responsive_screens/banners_tablet.dart';

class BannersScreen extends StatelessWidget {
  const BannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: BannersDesktopScreen(),
      tablet: BannersTabletScreen(),
      mobile: BannersMobileScreen(),
    );
  }
}
