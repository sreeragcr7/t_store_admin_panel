import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/features/shop/models/order_mode.dart';
import 'package:t_store_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:t_store_admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  //Firestore inatance for database interactions
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /*----------------------------- FUNCTIONS ------------------------------------*/

  //Get all orders related to the current user
  Future<List<OrderModel>> getAllOrders() async {
    try {
      print('🔄 Fetching all orders from nested structure...');
      
      // First, get all users
      final usersSnapshot = await _db.collection('Users').get();
      print('📋 Found ${usersSnapshot.docs.length} users');
      
      List<OrderModel> allOrders = [];
      
      // For each user, fetch their orders
      for (var userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        print('👤 Fetching orders for user: $userId');
        
        try {
          final ordersSnapshot = await _db
              .collection('Users')
              .doc(userId)
              .collection('Orders')
              .get();
          
          print('📦 User $userId has ${ordersSnapshot.docs.length} orders');
          
          // Convert each order document to OrderModel
          for (var orderDoc in ordersSnapshot.docs) {
            try {
              final order = OrderModel.fromSnapshot(orderDoc);
              allOrders.add(order);
              print('✅ Loaded order: ${order.id}');
            } catch (e) {
              print('❌ Error parsing order ${orderDoc.id}: $e');
            }
          }
        } catch (e) {
          print('❌ Error fetching orders for user $userId: $e');
        }
      }
      
      print('🎉 Successfully loaded ${allOrders.length} total orders');
      return allOrders;
      
    } catch (e) {
      print('❌ Error in getAllOrders: $e');
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return [];
    }
  }

  //Store a new user order
  Future<void> addOrder(OrderModel order) async {
    try {
      await _db.collection('Orders').add(order.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Update a specific value of a order instance
 Future<void> updateOrderSpecificValue(String orderDocId, Map<String, dynamic> data) async {
    try {
      // We need to find which user this order belongs to first
      final usersSnapshot = await _db.collection('Users').get();
      
      for (var userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final orderRef = _db
            .collection('Users')
            .doc(userId)
            .collection('Orders')
            .doc(orderDocId);
        
        final orderDoc = await orderRef.get();
        if (orderDoc.exists) {
          await orderRef.update(data);
          print('✅ Updated order $orderDocId for user $userId');
          return;
        }
      }
      
      throw 'Order not found';
    } catch (e) {
      print('❌ Error updating order: $e');
      throw e.toString();
    }
  }

  //Delete an Order
   Future<void> deleteOrder(String orderDocId) async {
    try {
      // Find which user this order belongs to
      final usersSnapshot = await _db.collection('Users').get();
      
      for (var userDoc in usersSnapshot.docs) {
        final userId = userDoc.id;
        final orderRef = _db
            .collection('Users')
            .doc(userId)
            .collection('Orders')
            .doc(orderDocId);
        
        final orderDoc = await orderRef.get();
        if (orderDoc.exists) {
          await orderRef.delete();
          print('✅ Deleted order $orderDocId for user $userId');
          return;
        }
      }
      
      throw 'Order not found';
    } catch (e) {
      print('❌ Error deleting order: $e');
      throw e.toString();
    }
  }
}
