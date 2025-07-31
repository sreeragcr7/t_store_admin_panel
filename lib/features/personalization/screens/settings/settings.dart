import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/personalization/screens/settings/responsive_screens/settings_desktop.dart';
import 'package:t_store_admin_panel/features/personalization/screens/settings/responsive_screens/settings_mobile.dart';
import 'package:t_store_admin_panel/features/personalization/screens/settings/responsive_screens/settings_tablet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: SettingsDesktopScreen(),
      tablet: SettingsTabletScreen(),
      mobile: SettingsMobileScreen(),
    );
  }
}
