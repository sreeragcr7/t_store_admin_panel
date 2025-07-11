import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String userId;
  final String docId;
  OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  // final AddressModel? address;
  final DateTime? deliveryDate;
  // final List<CartItemModel> items;

  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
    required this.status,
    // required this.items
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paypal',
    // this.address
    this.deliveryDate,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null ? THelperFunctions.getFormattedDate(deliveryDate!) : '';

  String get orderStatusText =>
      status == OrderStatus.delivered
          ? 'Delivered'
          : status == OrderStatus.shipped
          ? 'Shiptment on the way'
          : 'Processing';

  //Static function to create an empty user model
  static OrderModel empty() =>
      OrderModel(id: '', orderDate: DateTime.now(), status: OrderStatus.pending, totalAmount: 0);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
    };
  }
}
