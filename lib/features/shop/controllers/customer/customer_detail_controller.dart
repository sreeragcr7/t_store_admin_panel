import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/data/repositories/address/address_repository.dart';
import 'package:t_store_admin_panel/data/repositories/user/user_repository.dart';
import 'package:t_store_admin_panel/features/personalization/models/user_model.dart';
import 'package:t_store_admin_panel/features/shop/models/order_mode.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class CustomerDetailController extends GetxController {
  static CustomerDetailController get instance => Get.find();

  RxBool ordersLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<bool> selectedRows = <bool>[].obs;
  Rx<UserModel> customer = UserModel.empty().obs;
  final addressRepository = Get.put(AddressRepository());
  final searchTextController = TextEditingController();
  RxList<OrderModel> allCustomerOrders = <OrderModel>[].obs;
  RxList<OrderModel> filteredCustomerOrders = <OrderModel>[].obs;

  //Load customer order
  Future<void> getCustomerOrders() async {
    try {
      //Show loader
      ordersLoading.value = true;

      //Fetch cutomer order and addresses
      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        customer.value.orders = await UserRepository.instance.fetchUserOrders(customer.value.id!);
      }

      //Update the categories list
      allCustomerOrders.assignAll(customer.value.orders ?? []);

      //Filter featured categories
      filteredCustomerOrders.assignAll(customer.value.orders ?? []);

      //Add all rows as false [Not selected] & Toggle when required
      selectedRows.assignAll(
        List.generate(customer.value.orders != null ? customer.value.orders!.length : 0, (index) => false),
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      ordersLoading.value = false;
    }
  }

  //Load customer orders
  Future<void> getCustomerAddresses() async {
    try {
      //Show loader while loding categories
      addressesLoading.value = true;

      //Fetch cutomer order & addresses
      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        customer.value.addresses = await addressRepository.fetchUserAddresses(customer.value.id!);
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      addressesLoading.value = false;
    }
  }

  //Search query Filter
  void searchQuery(String query) {
    filteredCustomerOrders.assignAll(
      allCustomerOrders.where(
        (customer) =>
            customer.id.toLowerCase().contains(query.toLowerCase()) ||
            customer.orderDate.toString().contains(query.toLowerCase()),
      ),
    );
    //Notify listener about the change
    update();
  }

  //Sorting related code
  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;
    filteredCustomerOrders.sort((a, b) {
      if (ascending) {
        return a.id.toLowerCase().compareTo(b.id.toLowerCase());
      } else {
        return b.id.toLowerCase().compareTo(a.id.toLowerCase());
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;
    update();
  }
}
