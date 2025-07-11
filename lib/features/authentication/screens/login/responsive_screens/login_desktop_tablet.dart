import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:t_store_admin_panel/features/authentication/screens/login/widgets/login_form.dart';
import 'package:t_store_admin_panel/features/authentication/screens/login/widgets/login_header.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(
      child: const Column(
        children: [
          //Header
          TLoginHeader(),

          //Form
          TLoginForm(),
        ],
      ),
    );
  }
}
