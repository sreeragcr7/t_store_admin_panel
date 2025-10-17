import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String? id;
  String imageUrl;
  bool active;
  String targetScreen;

  BannerModel({this.id, required this.active, required this.imageUrl, required this.targetScreen});

  Map<String, dynamic> toJson() {
    return {'ImageUrl': imageUrl, 'Active': active, 'TargetScreen': targetScreen};
  }

  // //Helper functions
  // static BannerModel empty() => BannerModel(id: '', name: '', image: '');

  // //formate date
  // String get formattedDate => TFormatter.formatDate(createdAt);
  // String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);

  // //Convert Model to Json structure so that you can store data in Firebase
  // toJson() {
  //   return {'Id': id, 'Name': name, 'Image': image, 'CreatedAt': createdAt, 'UpdatedAt': updatedAt = DateTime.now()};
  // }

  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BannerModel(
      id: snapshot.id,
      imageUrl: data['ImageUrl'] ?? '',
      active: data['Active'] ?? false,
      targetScreen: data['TargetScreen'] ?? '',
    );
  }
}
