import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/utils/formatters/formatters.dart';

class CategoryModel {
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured = false,
    this.parentId = '',
    this.createdAt,
    this.updatedAt,
  });

  //Empty helper function
  static CategoryModel empty() => CategoryModel(id: '', name: '', image: '', isFeatured: false);

  CategoryModel copyWith({
    String? id,
    String? name,
    String? image,
    String? parentId,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      parentId: parentId ?? this.parentId,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  //formate date
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  // Convert ID to int for sorting
  int get numericId => int.tryParse(id) ?? 0;

  //Convert Model to Json structure so that you can store data in Firebase
  toJson() {
    return {
      'Name': name,
      'Image': image,
      'ParentId': parentId,
      'IsFeatured': isFeatured,
      'CreatedAt': createdAt?.toUtc(), //!createdAt
      'UpdatedAt': updatedAt?.toUtc(), //!DateTime.now()
    };
  }

  //Map Json oriented document snapshot from Firebase to UserModel
  factory CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      // Handle Timestamps
      final createdAt = data['CreatedAt'] as Timestamp?;
      final updatedAt = data['UpdatedAt'] as Timestamp?;

      //Map JSON Record to the Model
      return CategoryModel(
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        parentId: data['ParentId'] ?? '',
        isFeatured: data['IsFeatured'] ?? false,
        createdAt: createdAt?.toDate(), // Convert to DateTime
        updatedAt: updatedAt?.toDate(), //
      );
    } else {
      return CategoryModel.empty();
    }
  }

  // Add fromImageModel constructor
factory CategoryModel.fromImageModel(ImageModel image, String name) {
  return CategoryModel(
    id: '',
    name: name,
    image: image.url,
    createdAt: DateTime.now(),
    isFeatured: false,
    parentId: '',
  );
}

  String get fullImageUrl {
    if (image.startsWith('http')) return image;

    final projectId = dotenv.env['SUPABASE_ID'];
    if (projectId == null || projectId.isEmpty) return image;

    // Handle both paths and full URLs
    if (image.startsWith('Images/')) {
      return 'https://$projectId.supabase.co/storage/v1/object/public/profile/$image';
    }
    return 'https://$projectId.supabase.co/storage/v1/object/public/profile/Images/Categories/$image';
  }
}
