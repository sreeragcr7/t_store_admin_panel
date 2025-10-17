import 'package:get/get.dart';
import 'package:t_store_admin_panel/features/shop/models/order_mode.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find();

  final RxList<double> weeklySales = <double>[].obs;
  final RxMap<OrderStatus, int> orderStatusData = <OrderStatus, int>{}.obs;
  final RxMap<OrderStatus, double> totalAmounts = <OrderStatus, double>{}.obs;

  // Order
  static final List<OrderModel> orders = [
    OrderModel(
      id: 'CWT0012',
      items: List.empty(),
      taxCost: 20,
      shippingCost: 20,
      status: OrderStatus.delivered,
      totalAmount: 256,
      orderDate: DateTime(2025, 5, 20),
      deliveryDate: DateTime(2025, 5, 20),
    ),
    OrderModel(
      id: 'CWT0012',
      items: List.empty(),
      taxCost: 20,
      shippingCost: 20,
      status: OrderStatus.delivered,
      totalAmount: 349,
      orderDate: DateTime(2025, 5, 21),
      deliveryDate: DateTime(2025, 5, 21),
    ),
    OrderModel(
      id: 'CWT0012',
      items: List.empty(),
      taxCost: 20,
      shippingCost: 20,
      status: OrderStatus.delivered,
      totalAmount: 520,
      orderDate: DateTime(2025, 5, 22),
      deliveryDate: DateTime(2025, 5, 22),
    ),
    OrderModel(
      id: 'CWT0012',
      items: List.empty(),
      taxCost: 20,
      shippingCost: 20,
      status: OrderStatus.shipped,
      totalAmount: 349,
      orderDate: DateTime(2025, 5, 23),
      deliveryDate: DateTime(2025, 5, 23),
    ),
    OrderModel(
      id: 'CWT0012',
      items: List.empty(),
      taxCost: 20,
      shippingCost: 20,
      status: OrderStatus.processing,
      totalAmount: 720,
      orderDate: DateTime(2025, 5, 24),
      deliveryDate: DateTime(2025, 5, 24),
    ),
    OrderModel(
      id: 'CWT0012',
      items: List.empty(),
      taxCost: 20,
      shippingCost: 20,
      status: OrderStatus.pending,
      totalAmount: 720,
      orderDate: DateTime(2025, 5, 24),
      deliveryDate: DateTime(2025, 5, 24),
    ),
    OrderModel(
      id: 'CWT0012',
      items: List.empty(),
      taxCost: 20,
      shippingCost: 20,
      status: OrderStatus.pending,
      totalAmount: 720,
      orderDate: DateTime(2025, 5, 24),
      deliveryDate: DateTime(2025, 5, 24),
    ),
    OrderModel(
      id: 'CWT0012',
      items: List.empty(),
      taxCost: 20,
      shippingCost: 20,
      status: OrderStatus.cancelled,
      totalAmount: 720,
      orderDate: DateTime(2025, 5, 24),
      deliveryDate: DateTime(2025, 5, 24),
    ),
  ];

  @override
  void onInit() {
    _calculateWeeklySales();
    _calculateOrderStatusData();
    super.onInit();
  }

  //Calculate weekly sales
  void _calculateWeeklySales() {
    //Reset WeeklySales to Zero
    weeklySales.value = List<double>.filled(7, 0.0);

    // Get current week start (Monday)
    final now = DateTime.now();
    final currentWeekStart = THelperFunctions.getStartOfWeek(now);

    for (var order in orders) {
      // Get start of week for the order
      final orderWeekStart = THelperFunctions.getStartOfWeek(order.orderDate);

      // Check if order is in current week
      if (orderWeekStart.isAtSameMomentAs(currentWeekStart)) {
        // Calculate day index (Monday = 0, Sunday = 6)
        int index = order.orderDate.weekday - 1;

        weeklySales[index] += order.totalAmount;
      }
    }
    // For debugging: Print the weekly sales
    print('Current Week Start: $currentWeekStart');
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

    for (var order in orders) {
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
}
