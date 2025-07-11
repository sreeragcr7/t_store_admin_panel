import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/responsive/responsive_design.dart';
import 'package:t_store_admin_panel/common/widgets/responsive/screens/desktop_layout.dart';
import 'package:t_store_admin_panel/common/widgets/responsive/screens/mobile_layout.dart';
import 'package:t_store_admin_panel/common/widgets/responsive/screens/tablet_layout.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';

class TSiteTemplate extends StatelessWidget {
  const TSiteTemplate({super.key, this.desktop, this.tablet, this.mobile, this.useLayout = true});

  // Widget for desktop layout
  final Widget? desktop;

  // Widget for Tablet layout
  final Widget? tablet;

  // Widget for Mobile layout
  final Widget? mobile;

  //Flag to determine weather to use the layout
  final bool useLayout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.softGrey,
      body: TResponsiveWidget(
        desktop: useLayout ? DesktopLayout(body: desktop) : desktop ?? Container(),
        tablet: useLayout ? TabletLayout(body: tablet ?? desktop) : tablet ?? desktop ?? Container(),
        mobile: useLayout ? MobileLayout(body: mobile ?? desktop) : mobile ?? desktop ?? Container(),
      ),
    );
  }
}
