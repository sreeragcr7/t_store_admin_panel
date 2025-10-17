import 'package:get/get.dart';
import 'package:t_store_admin_panel/features/personalization/controllers/user_controllers.dart';
import 'package:t_store_admin_panel/features/personalization/controllers/settings_controller.dart';
// import 'package:t_store_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserControllers(), fenix: true);
    // Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}
