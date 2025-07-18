import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/headers/header.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/sidebars/sidebar.dart';

class MobileLayout extends StatelessWidget {
  MobileLayout({super.key, this.body});

  final Widget? body;

  final GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const TSidebar(),
      appBar: THeader(scaffoldKey: scaffoldKey),
      body: body ?? const SizedBox(), //Body
    );
  }
}
