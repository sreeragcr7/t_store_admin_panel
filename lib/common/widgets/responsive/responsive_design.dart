import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class TResponsiveWidget extends StatelessWidget {
  const TResponsiveWidget({super.key, required this.desktop, required this.tablet, required this.mobile});

  // Widget for desktop layout
  final Widget desktop;

  // Widget for Tablet layout
  final Widget tablet;

  // Widget for Mobile layout
  final Widget mobile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= TSizes.desktopScreenSize) {
          return desktop;
        } else if (constraints.maxWidth < TSizes.desktopScreenSize && constraints.maxWidth >= TSizes.tabletScreenSize) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
