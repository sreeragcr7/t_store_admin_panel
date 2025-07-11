import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';

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
}
