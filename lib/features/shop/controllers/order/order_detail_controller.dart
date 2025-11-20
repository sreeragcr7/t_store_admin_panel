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
      print('🔄 Fetching customer for order: ${order.value.id}');
      print('👤 UserId: ${order.value.userId}');
      
      loading.value = true;
      
      if (order.value.userId.isEmpty) {
        print('❌ No userId found for order');
        customer.value = UserModel.empty();
        return;
      }

      // Fetch customer details
      final user = await UserRepository.instance.fetchUserById(order.value.userId);
      
      if (user.id == null) {
        print('❌ Customer not found for userId: ${order.value.userId}');
        customer.value = UserModel.empty();
      } else {
        print('✅ Found customer: ${user.fullName} (${user.email})');
        customer.value = user;
      }
    } catch (e) {
      print('❌ Error fetching customer: $e');
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      customer.value = UserModel.empty();
    } finally {
      loading.value = false;
    }
  }
}
