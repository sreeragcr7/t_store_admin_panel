import 'package:get/get.dart';
import 'package:t_store_admin_panel/features/authentication/controllers/user_controllers.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserControllers(), fenix: true);
  }
}
