import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:t_store_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store_admin_panel/routes/routes.dart';

class TRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AuthenticationRepository.instance.isAuthenticated ? null : const RouteSettings(name: TRoutes.login);
  }
}
