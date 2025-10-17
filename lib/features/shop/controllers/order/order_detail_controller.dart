import 'package:get/get.dart';
import 'package:t_store_admin_panel/data/repositories/user/user_repository.dart';
import 'package:t_store_admin_panel/features/personalization/models/user_model.dart';
import 'package:t_store_admin_panel/features/shop/models/order_mode.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class OrderDetailController extends GetxController {
  static OrderDetailController get inatance => Get.find();

  RxBool loading = true.obs;
  Rx<OrderModel> order = OrderModel.empty().obs;
  Rx<UserModel> customer = UserModel.empty().obs;

  //Load customer orders
  Future<void> getCustomerOfCurrentOrder() async {
    try {
      //Show loader while loading categories
      loading.value = true;
      //Fetch customer orders & addresses
      final user = await UserRepository.instance.fetchUserDetails(order.value.userId);

      customer.value = user;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      loading.value = false;
    }
  }
}
