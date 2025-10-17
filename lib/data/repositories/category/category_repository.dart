import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/features/shop/models/category_model.dart';
import 'package:t_store_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:t_store_admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:t_store_admin_panel/utils/providers/supabase_provide.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  //Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get all categories from 'Categories' collection
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      final result = snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Create a new category document in the 'Categories' collection
  Future<String> createCategory(CategoryModel category) async {
    try {
      final counterRef = _db.collection('counters').doc('categories');
      final counterDoc = await counterRef.get();

      int lastId = 0;
      if (counterDoc.exists) {
        // Handle null or missing lastId field
        final data = counterDoc.data()!;
        lastId = (data['lastId'] ?? 0) as int;
      }

      final newId = lastId + 1;

      final batch = _db.batch();
      batch.set(counterRef, {'lastId': newId}, SetOptions(merge: true));

      final catRef = _db.collection('Categories').doc(newId.toString());
      batch.set(catRef, category.toJson());

      await batch.commit();
      return newId.toString();
    } on FirebaseException catch (e) {
      print('🔥 FirebaseException: ${e.code} - ${e.message}');
      throw 'Firestore error: ${e.message}';
    } on PlatformException catch (e) {
      print('📱 PlatformException: ${e.code} - ${e.message}');
      throw 'Platform error: ${e.message}';
    } catch (e) {
      print('❌ UNKNOWN ERROR: $e');
      throw 'Operation failed: $e';
    }
  }

  //Update
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _db.collection('Categories').doc(category.id).update(category.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //delete
  Future<void> deleteCategory(String categoryId) async {
    try {
      // Get the category document first to access image URL
      final doc = await _db.collection('Categories').doc(categoryId).get();
      if (!doc.exists) return;

      final category = CategoryModel.fromSnapshot(doc);

      // Delete image from Supabase if exists
      if (category.fullImageUrl.isNotEmpty) {
        await SupabaseProvider().deleteImage(category.fullImageUrl);
      }

      // Delete Firestore document
      await _db.collection('Categories').doc(categoryId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
