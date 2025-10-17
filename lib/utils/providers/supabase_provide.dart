import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider {
  static final SupabaseProvider _instance = SupabaseProvider._internal();
  factory SupabaseProvider() => _instance;
  SupabaseProvider._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> deleteImage(String publicUrl) async {
    try {
      final uri = Uri.parse(publicUrl);
      final pathSegments = uri.pathSegments;

      if (pathSegments.length < 6) {
        throw 'Invalid image URL format';
      }

      final bucket = pathSegments[4];
      final filePath = pathSegments.sublist(5).join('/');

      await _supabase.storage.from(bucket).remove([filePath]);
    } catch (e) {
      throw 'Failed to delete image: $e';
    }
  }
}
