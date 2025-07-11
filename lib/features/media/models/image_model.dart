import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_store_admin_panel/utils/formatters/formatters.dart';
import 'package:universal_html/html.dart';
import 'dart:typed_data';

import 'package:get/get_rx/get_rx.dart';

class ImageModel {
  String id;
  final String url;
  final String folder;
  final int? sizeBytes;
  String mediaCategory;
  final String filename;
  final String? fullPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;

  //Not Mapped
  final File? file;
  RxBool isSeleceted = false.obs;
  final Uint8List? localImageToDisplay;

  ImageModel({
    this.id = '',
    required this.url,
    required this.folder,
    required this.filename,
    this.sizeBytes,
    this.fullPath,
    this.createdAt,
    this.updatedAt,
    this.contentType,
    this.file,
    this.localImageToDisplay,
    this.mediaCategory = '',
  });

  //Static function to create an empty user model.

  static ImageModel empty() => ImageModel(url: '', folder: '', filename: '');

  String get createdAtFormatted => TFormatter.formatDate(createdAt);
  String get updatedAtFormatted => TFormatter.formatDate(updatedAt);

  //Convert to json to store in DB
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'folder': folder,
      'sizeBytes': sizeBytes,
      'filename': filename,
      'fullPath': fullPath,
      'createdAt': createdAt?.toUtc(),
      'contentType': contentType,
      'mediaCategory': mediaCategory,
    };
  }

  //Convert Firestore Json & map on model
  factory ImageModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      //Map Json record to the model
      return ImageModel(
        id: document.id,
        url: data['url'] ?? '',
        folder: data['folder'] ?? '',
        sizeBytes: data['sizeBytes'] ?? 0,
        filename: data['filename'] ?? '',
        fullPath: data['fullPath'] ?? '',
        createdAt: data.containsKey('createdAt') ? data['createdAt']?.toDate() : null,
        updatedAt: data.containsKey('updatedAt') ? data['updatedAt']?.toDate() : null,
        contentType: data['contentType'] ?? '',
        mediaCategory: data['mediaCategory'],
      );
    } else {
      return ImageModel.empty();
    }
  }

  //Map Firebase storage data
  factory ImageModel.fromSupabaseUpload({required String url,
  required String folder,
  required String filename,
  required int sizeBytes,
  required String fullPath,
  String? contentType,
  DateTime? createdAt,
   DateTime? updatedAt,
  }) {
    return ImageModel(
      url: url,
      folder: folder,
      fullPath: fullPath,
      filename: filename,
      sizeBytes: sizeBytes,
      updatedAt: updatedAt,
      contentType: contentType,
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
