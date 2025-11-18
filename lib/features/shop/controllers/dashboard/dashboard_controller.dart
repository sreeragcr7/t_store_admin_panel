import 'package:get/get.dart';
import 'package:t_store_admin_panel/data/abstract/base_data_table_controller.dart';
import 'package:t_store_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:t_store_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/order_mode.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';

class DashboardController extends TBaseController<OrderModel> {
  static DashboardController get instance => Get.find();

  final orderController = Get.put(OrderController());
  final customerController = Get.put(CustomerController());

  final RxList<double> weeklySales = <double>[].obs;
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;

  @override
  Future<List<OrderModel>> fetchItems() async {
    //Fetch order if empty
    if (orderController.allItems.isEmpty) {
      await orderController.fetchItems();
    }

    //Fetch order if empty
    if (customerController.allItems.isEmpty) {
      await customerController.fetchItems();
    }

    //Calculate weekly sales
    _calculateWeeklySales();

    //Calculate Order status counts
    _calculateOrderStatusData();

    return orderController.allItems;
  }

 

  //Calculate weekly sales
  void _calculateWeeklySales() {
    //Reset WeeklySales to Zero
    weeklySales.value = List<double>.filled(7, 0.0);

    for (var order in orderController.allItems) {
      final DateTime orderWeekStart = THelperFunctions.getStartOfWeek(order.orderDate);

      // Check if order is in current week
      if (orderWeekStart.isBefore(DateTime.now()) &&
          orderWeekStart.add(const Duration(days: 7)).isAfter(DateTime.now())) {
        int index = (order.orderDate.weekday - 1) % 7;

        //Ensure the index is non negative
        index = index < 0 ? index + 7 : index;

        weeklySales[index] += order.totalAmount;
      }
    }
    // For debugging: Print the weekly sales
    print('Weekly Sales: $weeklySales');

    // If no sales, show sample data for demo
    if (weeklySales.every((sale) => sale == 0)) {
      print('No sales this week - showing sample data');
      weeklySales.value = [120, 300, 240, 420, 360, 180, 280].map((e) => e.toDouble()).toList();
    }
  }

  //Calculate order status counts
  void _calculateOrderStatusData() {
    //Reset status data
    orderStatusData.clear();

    //Map to store the total amount for each status
    totalAmounts.value = {for (var status in OrderStatus.values) status: 0.0};

    for (var order in orderController.allItems) {
      //Count Orders
      final status = order.status;
      orderStatusData[status] = (orderStatusData[status] ?? 0) + 1;

      //Calculate total amounts for each status
      totalAmounts[status] = (totalAmounts[status] ?? 0) + order.totalAmount;
    }
  }

  String getDisplayStatusName(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  bool containsSearchQuery(OrderModel item, String query) => false;

  @override
  Future<void> deleteItem(OrderModel item) async {}
}
