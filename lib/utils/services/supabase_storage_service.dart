// services/supabase_storage_service.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String bucketName = 'profile';

  // Upload single image
  static Future<String> uploadImage(XFile imageFile, String folderPath) async {
    try {
      final File file = File(imageFile.path);
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final String filePath = '$folderPath/$fileName';
      
      // Upload file - this now returns the file path directly
      final String uploadedFilePath = await _supabase.storage
          .from(bucketName)
          .upload(filePath, file);
      
      // Get public URL
      final String publicUrl = _supabase.storage
          .from(bucketName)
          .getPublicUrl(uploadedFilePath);
      
      return publicUrl;
    } catch (e) {
      throw 'Failed to upload image: $e';
    }
  }

  // Upload multiple images
  static Future<List<String>> uploadMultipleImages(
    List<XFile> imageFiles, 
    String folderPath
  ) async {
    final List<String> urls = [];
    
    for (final imageFile in imageFiles) {
      final url = await uploadImage(imageFile, folderPath);
      urls.add(url);
    }
    
    return urls;
  }

  // Delete image
  static Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract file path from URL
      final Uri uri = Uri.parse(imageUrl);
      final String filePath = uri.path.split('/$bucketName/').last;
      
      await _supabase.storage
          .from(bucketName)
          .remove([filePath]);
    } catch (e) {
      throw 'Failed to delete image: $e';
    }
  }
}

// import 'dart:typed_data';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class SupabaseStorageService {
//   static SupabaseStorageService get instance => SupabaseStorageService();

//   final _supabase = Supabase.instance.client;

//   Future<String> uploadImage({
//     required Uint8List imageBytes,
//     required String fileName,
//     required String bucket,
//     String folder = 'Categories',
//   }) async {
//     try {
//       // 1. Validate environment
//       final projectId = dotenv.env['SUPABASE_ID'];
//       if (projectId == null) throw 'Supabase project ID not found';

//       // 2. Prepare upload path
//       final path = '$folder/$fileName';
//       print('⬆️ Uploading to: $bucket/$path');
//       print('📦 File size: ${imageBytes.length} bytes');

//       // 3. Perform actual upload
//       await _supabase.storage
//           .from(bucket)
//           .uploadBinary(path, imageBytes, fileOptions: FileOptions(contentType: _getMimeType(fileName), upsert: true));

//       print('✅ Upload successful: $fileName');
//       return fileName;
//     } on StorageException catch (e) {
//       print('❌ StorageException: ${e.message}');
//       rethrow;
//     } catch (e, stack) {
//       print('❌ Upload failed: $e');
//       print('🔥 Stack trace: $stack');
//       rethrow;
//     }
//   }

//   String _getMimeType(String fileName) {
//     final ext = fileName.split('.').last.toLowerCase();
//     switch (ext) {
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       case 'png':
//         return 'image/png';
//       case 'gif':
//         return 'image/gif';
//       case 'webp':
//         return 'image/webp';
//       default:
//         return 'application/octet-stream';
//     }
//   }
// }
