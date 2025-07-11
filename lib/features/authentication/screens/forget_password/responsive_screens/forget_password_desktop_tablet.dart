import 'package:flutter/material.dart';

import 'package:t_store_admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:t_store_admin_panel/features/authentication/screens/forget_password/widgets/header_form.dart';

class ForgetPasswordDesktopTablet extends StatelessWidget {
  const ForgetPasswordDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(child: HeaderAndForm());
  }
}
