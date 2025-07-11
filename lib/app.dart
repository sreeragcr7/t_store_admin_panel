import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:t_store_admin_panel/bindings/general_bindings.dart';
import 'package:t_store_admin_panel/routes/app_routes.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/text_strings.dart';
import 'package:t_store_admin_panel/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      getPages: TAppRoutes.pages,
      initialBinding: GeneralBindings(),
      initialRoute: TRoutes.dashboard,
      unknownRoute: GetPage(
        name: '/page-not-found',
        page: () => const Scaffold(body: Center(child: Text('Page Not Found!'))),
      ),
      // home: const FirstScreen(),
    );
  }
}
