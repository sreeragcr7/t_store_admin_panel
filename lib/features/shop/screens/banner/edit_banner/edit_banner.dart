import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/edit_banner/responsive_screen/edit_banner_desktop.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/edit_banner/responsive_screen/edit_banner_mobile.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/edit_banner/responsive_screen/edit_banner_tablet.dart';

class EditBannerScreen extends StatelessWidget {
  const EditBannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: EditBannerDesktopScreen(),
      tablet: EditBannerTabletScreen(),
      mobile: EditBannerMobileScreen(),
    );
  }
}
