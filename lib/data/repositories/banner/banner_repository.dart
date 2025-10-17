import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_store_admin_panel/features/shop/models/banner_model.dart';
import 'package:t_store_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:t_store_admin_panel/utils/exceptions/platform_exceptions.dart';

class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  //Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  //Get all Banner from 'Banners' collection
  Future<List<BannerModel>> getAllBanners() async {
    try {
      final snapshot = await _db.collection('Banners').get();
      final result = snapshot.docs.map((doc) => BannerModel.fromSnapshot(doc)).toList();
      return result;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Create a new banser document in the 'Banners' collection
  Future<String> createBanner(BannerModel banner) async {
    try {
      final counterRef = _db.collection('counters').doc('banners');
      final counterDoc = await counterRef.get();

      int lastId2 = 0;
      if (counterDoc.exists) {
        // Handle null or missing lastId field
        final data = counterDoc.data()!;
        lastId2 = (data['lastId3'] ?? 0) as int;
      }

      final newId = lastId2 + 1;

      final batch = _db.batch();
      batch.set(counterRef, {'lastId3': newId}, SetOptions(merge: true));

      final catRef = _db.collection('Banners').doc(newId.toString());
      batch.set(catRef, banner.toJson());

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

  //Update an existing brand document in the 'Brands' collection
  Future<void> updateBanner(BannerModel banner) async {
    try {
      await _db.collection('Banners').doc(banner.id).update(banner.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Delete en existing brand document and its associated brand categories
  Future<void> deleteBanner(BannerModel banner) async {
    try {
      await _db.collection('Banners').doc(banner.id).delete();

      // Then delete the image from Supabase storage
      await _deleteImageFromSupabase(banner.imageUrl);
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
      await _supabase.storage.from('profile').remove(['Banners/$fileName']);
    } catch (e) {
      print('Error deleting image from Supabase: $e');
      // Don't throw error as the main brand deletion was successful
      // You might want to log this error to a monitoring service
    }
  }
}
