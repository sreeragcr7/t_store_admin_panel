import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_store_admin_panel/features/shop/models/category_model.dart';
import 'package:t_store_admin_panel/utils/formatters/formatters.dart';

class BrandModel {
  String id;
  String name;
  String image;
  bool isFeatured;
  int? productsCount;
  DateTime? createdAt;
  DateTime? updatedAt;

  //Not Mapped
  List<CategoryModel>? brandCategories;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
    this.isFeatured = false,
    this.productsCount,
    this.createdAt,
    this.updatedAt,
    this.brandCategories,
  });

  //Helper functions
  static BrandModel empty() => BrandModel(id: '', name: '', image: '');

  //formate date
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  //Convert Model to Json structure so that you can store data in Firebase
  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'IsFeatured': isFeatured,
      'ProductsCount': productsCount = 0,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  //Map Json oriented document snapshot from Firebase to UserModel
  factory BrandModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      // Handle Timestamps
      final createdAt = data['CreatedAt'] as Timestamp?;
      final updatedAt = data['UpdatedAt'] as Timestamp?;

      //Map JSON Record to the Model
      return BrandModel(
        id: document.id,
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        productsCount: data['ProductsCount'] ?? '',
        isFeatured: data['IsFeatured'] ?? false,
        createdAt: createdAt?.toDate(), // Convert to DateTime
        updatedAt: updatedAt?.toDate(), //
      );
    } else {
      return BrandModel.empty();
    }
  }

  factory BrandModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) return BrandModel.empty();

    // Handle Timestamps
    final createdAt = data['CreatedAt'] as Timestamp?;
    final updatedAt = data['UpdatedAt'] as Timestamp?;

    return BrandModel(
      id: data['Id'] ?? '',
      name: data['Name'] ?? '',
      image: data['Image'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
      productsCount: int.parse((data['ProductsCount'] ?? 0).toString()),
      createdAt: createdAt?.toDate(), // Convert to DateTime
      updatedAt: updatedAt?.toDate(), //
    );
  }


}
