import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_store_admin_panel/features/personalization/models/address_model.dart';
import 'package:t_store_admin_panel/features/shop/models/cart_item_model.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';

class OrderModel {
  final String id;
  final String docId;
  final String userId;
  OrderStatus status;
  final double totalAmount;
  final double shippingCost;
  final double taxCost;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? shippingAddress;
  final AddressModel? billingAddress;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;
  final bool billingAddressSameAsShipping;

  OrderModel({
    required this.id,
    this.userId = '',
    this.docId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxCost,
    required this.orderDate,
    this.paymentMethod = 'Cash on Delivery',
    this.billingAddress,
    this.shippingAddress,
    this.deliveryDate,
    this.billingAddressSameAsShipping = true,
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
  static OrderModel empty() => OrderModel(
    id: '',
    items: [],
    orderDate: DateTime.now(),
    status: OrderStatus.pending,
    totalAmount: 0,
    shippingCost: 0,
    taxCost: 0,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'billingAddress': billingAddress?.toJson(),
      'shippingAddress': shippingAddress?.toJson(),
      'deliveryDate': deliveryDate,
      'billingAddressSameAsShipping': billingAddressSameAsShipping,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
  final data = snapshot.data() as Map<String, dynamic>;
  
  print('🔄 Parsing order data: ${snapshot.id}');
  print('📊 Raw data keys: ${data.keys.toList()}');

  // Parse items
  List<CartItemModel> items = [];
  if (data.containsKey('Items') && data['Items'] is List) { // Note: Capital 'I'
    try {
      items = (data['Items'] as List<dynamic>).map((itemData) {
        return CartItemModel.fromJson(itemData as Map<String, dynamic>);
      }).toList();
      print('✅ Parsed ${items.length} items');
    } catch (e) {
      print('❌ Error parsing items: $e');
    }
  } else {
    print('⚠️ No Items field found or not a list');
  }

  // Parse numeric fields - match your Firestore field names
  double totalAmount = 0.0;
  if (data.containsKey('TotalAmount')) { // Note: Capital 'T', capital 'A'
    final totalAmountData = data['TotalAmount'];
    if (totalAmountData is int) {
      totalAmount = totalAmountData.toDouble();
    } else if (totalAmountData is double) {
      totalAmount = totalAmountData;
    } else if (totalAmountData is String) {
      totalAmount = double.tryParse(totalAmountData) ?? 0.0;
    }
    print('💰 Total Amount: $totalAmount (raw: $totalAmountData)');
  } else {
    print('⚠️ No TotalAmount field found');
  }

  // Parse other fields with correct capitalization
  DateTime orderDate = DateTime.now();
  if (data.containsKey('OrderDate')) { // Note: Capital 'O', capital 'D'
    orderDate = (data['OrderDate'] as Timestamp).toDate();
    print('📅 Order Date: $orderDate');
  } else if (data.containsKey('DateTime')) {
    orderDate = (data['DateTime'] as Timestamp).toDate();
    print('📅 Using DateTime as Order Date: $orderDate');
  }

  // Parse status - handle the string format "OrderStatus.pending"
  OrderStatus status = OrderStatus.pending;
  if (data.containsKey('Status')) {
    final statusString = data['Status'] as String;
    print('📋 Raw Status: $statusString');
    
    // Extract just the status name from "OrderStatus.pending"
    if (statusString.contains('.')) {
      final statusName = statusString.split('.').last;
      status = OrderStatus.values.firstWhere(
        (e) => e.name == statusName,
        orElse: () => OrderStatus.pending,
      );
    } else {
      status = OrderStatus.values.firstWhere(
        (e) => e.name == statusString,
        orElse: () => OrderStatus.pending,
      );
    }
    print('✅ Parsed Status: ${status.name}');
  }

  String paymentMethod = 'Cash on Delivery';
  if (data.containsKey('PaymentMethod')) { // Note: Capital 'P', capital 'M'
    paymentMethod = data['PaymentMethod'] as String;
  }

  // Parse shipping address from top-level fields
  AddressModel? shippingAddress;
  if (data.containsKey('City') || data.containsKey('Street')) {
    shippingAddress = AddressModel(
      id: data.containsKey('Id') ? data['Id'] as String : '',
      name: data.containsKey('Name') ? data['Name'] as String : '',
      phoneNumber: data.containsKey('PhoneNumber') ? data['PhoneNumber'] as String : '',
      street: data.containsKey('Street') ? data['Street'] as String : '',
      city: data.containsKey('City') ? data['City'] as String : '',
      state: data.containsKey('State') ? data['State'] as String : '',
      postalCode: data.containsKey('PostalCode') ? data['PostalCode'] as String : '',
      country: data.containsKey('Country') ? data['Country'] as String : '',
    );
    print('📍 Parsed shipping address');
  }

  return OrderModel(
    docId: snapshot.id,
    id: data.containsKey('Id') ? data['Id'] as String : snapshot.id,
    userId: data.containsKey('UserId') ? data['UserId'] as String : _getUserIdFromPath(snapshot.reference.path),
    status: status,
    totalAmount: totalAmount,
    shippingCost: 0.0, // You might want to add this field to Firestore
    taxCost: 0.0, // You might want to add this field to Firestore
    orderDate: orderDate,
    paymentMethod: paymentMethod,
    billingAddressSameAsShipping: true, // Default to true
    billingAddress: shippingAddress, // Use same as shipping for now
    shippingAddress: shippingAddress,
    deliveryDate: data.containsKey('DeliveryDate') && data['DeliveryDate'] != null
        ? (data['DeliveryDate'] as Timestamp).toDate()
        : null,
    items: items,
  );
}

  // Helper method to extract userId from Firestore path
  static String _getUserIdFromPath(String path) {
    final pathSegments = path.split('/');
    // Path format: Users/{userId}/Orders/{orderId}
    if (pathSegments.length >= 2 && pathSegments[0] == 'Users') {
      return pathSegments[1];
    }
    return '';
  }
}
