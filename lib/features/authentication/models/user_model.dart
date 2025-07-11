import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/formatters/formatters.dart';

class UserModel {
  final String? id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phoneNumber;
  String profilePicture;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;

  ///Constructor for UserModel
  UserModel({
    this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
  });

  //Helper methods
  String get fullName => '$firstName $lastName';
  String get formatteDate => TFormatter.formatDate(createdAt);
  String get formatteUpdatedAtDate => TFormatter.formatDate(updatedAt);
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  ///Static function to create an empty user model
  static UserModel empty() => UserModel(email: "");

  ///Convert model to jSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role': role.name.toString(),
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  ///Factory method to create a UserModel from a Firebase document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data.containsKey('FirstName') ? data["FirstName"] ?? "" : "",
        lastName: data.containsKey('LastName') ? data["LastName"] ?? "" : "",
        username: data.containsKey('Username') ? data["Username"] ?? "" : "",
        email: data.containsKey('Email') ? data["Email"] ?? "" : "",
        phoneNumber: data.containsKey('PhoneNumber') ? data["PhoneNumber"] ?? "" : "",
        profilePicture: data.containsKey('ProfilePicture') ? data["ProfilePicture"] ?? "" : "",
        role: data.containsKey('Role') ? (data["Role"] ?? AppRole.user) == AppRole.admin.name.toString() ? AppRole.admin : AppRole.user : AppRole.user,
        createdAt: data.containsKey('CreatedAt') ? data["CreatedAt"]?.toDate() ?? DateTime.now() : DateTime.now(),
        updatedAt: data.containsKey('UpdatedAt') ? data["UpdatedAt"]?.toDate() ?? DateTime.now() : DateTime.now(),
        
      );
    } else {
      return empty();
    }
  }
}
