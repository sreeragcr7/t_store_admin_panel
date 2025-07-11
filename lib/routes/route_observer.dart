import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/sidebars/sidebar_controller.dart';
import 'package:t_store_admin_panel/routes/routes.dart';

class TRouteObservers extends GetObserver {
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sidebarController = Get.put(SidebarController());

    if (previousRoute != null) {
      //Check the route name & update the active item in the sidebar accordingly
      for (var routeName in TRoutes.sideMenuItems) {
        if (previousRoute.settings.name == routeName) {
          sidebarController.activeItem.value = routeName;
        }
      }
    }
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sidebarController = Get.put(SidebarController());

    if (route != null) {
      //Check the route name & update the active item in the sidebar accordingly
      for (var routeName in TRoutes.sideMenuItems) {
        if (route.settings.name == routeName) {
          sidebarController.activeItem.value = routeName;
        }
      }
    }
  }
}
