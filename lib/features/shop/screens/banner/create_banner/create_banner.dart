import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/create_banner/responsive_screen/create_banner_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/create_banner/responsive_screen/create_banner_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/create_banner/responsive_screen/create_banner_tablet.dart';

class CreateBannerScreen extends StatelessWidget {
  const CreateBannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: CreateBannerDesktopScreen(),
      tablet: CreateBannerTabletScreen(),
      mobile: CreateBannerMobileScreen(),
    );
  }
}
