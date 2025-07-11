import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/site_template.dart';
import 'package:t_store_admin_panel/features/authentication/screens/login/responsive_screens/login_desktop_tablet.dart';
import 'package:t_store_admin_panel/features/authentication/screens/login/responsive_screens/login_mobile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(useLayout: false, desktop: LoginScreenDesktopTablet(), mobile: LoginScreenMobile());
  }
}
