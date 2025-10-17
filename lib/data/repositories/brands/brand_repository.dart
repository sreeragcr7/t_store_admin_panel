import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_store_admin_panel/features/shop/models/brand_category_model.dart';
import 'package:t_store_admin_panel/features/shop/models/brand_model.dart';
import 'package:t_store_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:t_store_admin_panel/utils/exceptions/platform_exceptions.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  //Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  //Get all categories from 'Brands' collection
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final snapshot = await _db.collection('Brands').get();
      final result = snapshot.docs.map((doc) => BrandModel.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Get all brand categories from the 'BrandCategory' collection
  Future<List<BrandCategoryModel>> getAllBrandCategories() async {
    try {
      final brandCategoryQuery = await _db.collection('BrandCategory').get();
      final brandCategories = brandCategoryQuery.docs.map((doc) => BrandCategoryModel.fromSnapshot(doc)).toList();
      return brandCategories;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Get specific brand categories for a given brand ID
  Future<List<BrandCategoryModel>> getCategoriesOfSpecificBrand(String brandId) async {
    try {
      final brandCategoryQuery = await _db.collection('BrandCategory').where('brandId', isEqualTo: brandId).get();
      final brandCategories = brandCategoryQuery.docs.map((doc) => BrandCategoryModel.fromSnapshot(doc)).toList();
      return brandCategories;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // //Create a new Brand document in the 'Brands' collection
  // Future<String> createBrand(BrandModel brand) async {
  //   try {
  //     final result = await _db.collection('Brands').add(brand.toJson());
  //     return result.id;
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  //Create a new brand document in the 'Brands' collection
  Future<String> createBrand(BrandModel category) async {
    try {
      final counterRef = _db.collection('counters').doc('brands');
      final counterDoc = await counterRef.get();

      int lastId2 = 0;
      if (counterDoc.exists) {
        // Handle null or missing lastId field
        final data = counterDoc.data()!;
        lastId2 = (data['lastId2'] ?? 0) as int;
      }

      final newId = lastId2 + 1;

      final batch = _db.batch();
      batch.set(counterRef, {'lastId2': newId}, SetOptions(merge: true));

      final catRef = _db.collection('Brands').doc(newId.toString());
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

  //Create a new brand category document in the 'BrandCategory' collection
  Future<String> createBrandCategory(BrandCategoryModel brandCategory) async {
    try {
      final result = await _db.collection('BrandCategory').add(brandCategory.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Update an existing brand document in the 'Brands' collection
  Future<void> updateBrand(BrandModel brand) async {
    try {
      await _db.collection('Brands').doc(brand.id).update(brand.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Delete en existing brand document and its associated brand categories
  Future<void> deleteBrand(BrandModel brand) async {
    try {
      await _db.runTransaction((transaction) async {
        final brandRef = _db.collection('Brands').doc(brand.id);
        final brandSnap = await transaction.get(brandRef);

        if (!brandSnap.exists) {
          throw Exception('Brand not found');
        }

        final brandCategoriesSnapshot =
            await _db.collection('BrandCategory').where('brandId', isEqualTo: brand.id).get();
        final brandCategories = brandCategoriesSnapshot.docs.map((e) => BrandCategoryModel.fromSnapshot(e));

        if (brandCategories.isNotEmpty) {
          for (var brandCategory in brandCategories) {
            transaction.delete(_db.collection('BrandCategory').doc(brandCategory.id));
          }
        }
        transaction.delete(brandRef);
      });
      // Delete the image from Supabase storage after successful transaction
      await _deleteImageFromSupabase(brand.image);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Delete a brand category document in the 'BrandCategory' collection
  Future<void> deleteBrandCategory(String brandCategoryId) async {
    try {
      await _db.collection('BrandCategory').doc(brandCategoryId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Helper method to delete image from Supabase
  Future<void> _deleteImageFromSupabase(String imagePath) async {
    try {
      // Extract just the filename from the path/URL
      String fileName = imagePath;

      // If it's a full URL, extract just the filename part
      if (imagePath.contains('/')) {
        fileName = imagePath.split('/').last;
      }

      // Delete from Supabase storage
      await _supabase.storage.from('profile').remove(['Brands/$fileName']);
    } catch (e) {
      print('Error deleting image from Supabase: $e');
      // Don't throw error as the main brand deletion was successful
      // You might want to log this error to a monitoring service
    }
  }
}
