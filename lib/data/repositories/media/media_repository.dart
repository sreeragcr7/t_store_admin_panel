import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';

class MediaRepository extends GetxController {
  static MediaRepository get instance => Get.find();

  //Supabase Storage instance
  final SupabaseStorageClient storage = Supabase.instance.client.storage;

  //Upload any Image using File
  Future<ImageModel> uploadImageFileInStorage({
    required Uint8List fileData,
    required String mimeType,
    required String path,
    required String imageName,
  }) async {
    // bucket name
    final bucket = storage.from('profile');
    final fullPath = '$path/$imageName';

    try {
      await bucket.uploadBinary(
        fullPath,
        fileData,
        fileOptions: FileOptions(
          contentType: mimeType,
          upsert: true, //optional
        ),
      );

      // Generate the public URL
      final publicUrl = bucket.getPublicUrl(fullPath);

      // Return the image model
      return ImageModel.fromSupabaseUpload(
        url: publicUrl,
        folder: path,
        filename: imageName,
        fullPath: fullPath,
        sizeBytes: fileData.lengthInBytes,
        contentType: mimeType,
      );
    } on StorageException catch (e) {
      throw 'Upload failed: ${e.message}';
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  //Upload Image data in Firestore
  Future<String> uploadImageFileInDatabase(ImageModel image) async {
    try {
      final data = await FirebaseFirestore.instance.collection('Images').add(image.toJson());
      return data.id;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  //Fetch images from Firestore based on media category & load count
  Future<List<ImageModel>> fetchImagesFromDatabase(MediaCategory mediaCategory, int loadCount) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('Images')
              .where('mediaCategory', isEqualTo: mediaCategory.name.toString())
              .orderBy('createdAt', descending: true)
              .limit(loadCount)
              .get();

      return querySnapshot.docs.map((e) => ImageModel.fromSnapShot(e)).toList();
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  //Load more images from firestore based on media category, load count & last fetched data.
  Future<List<ImageModel>> loadMoreImagesFromDatabase(
    MediaCategory mediaCategory,
    int loadCount,
    DateTime lastFetchedData,
  ) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('Images')
              .where('mediaCategory', isEqualTo: mediaCategory.name.toString())
              .orderBy('createdAt', descending: true)
              .startAfter([lastFetchedData])
              .limit(loadCount)
              .get();

      return querySnapshot.docs.map((e) => ImageModel.fromSnapShot(e)).toList();
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }

  //Delete file from Supabase Storage and corresponding documnet from supabase
  Future<void> deleteFileFromStorage(ImageModel image) async {
    try {
      //Delete the image file from Supabase Storage
      final bucket = Supabase.instance.client.storage.from('profile');
      await bucket.remove([image.fullPath ?? '']);

      //Delete the image metadata from Firestore
      await FirebaseFirestore.instance.collection('Images').doc(image.id).delete();
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong while deleting image';
    }
  }
}
