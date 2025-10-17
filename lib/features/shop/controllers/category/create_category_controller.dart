import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_store_admin_panel/data/repositories/category/category_repository.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/category_model.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class CreateCategoryController extends GetxController {
  static CreateCategoryController get instance => Get.find();

  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
   // Add variable to store selected image model
  final Rx<ImageModel?> selectedImageModel = Rx<ImageModel?>(null);

  //Init Data

  //Method to reset fields


  // Update method to copy images within the same bucket
  Future<String> copyImageToCategoryFolder(ImageModel originalImage) async {
    try {
      final storage = Supabase.instance.client.storage;
      final bucket = storage.from('profile');

      // Extract just the filename from the full path
      final fileName = originalImage.filename;

      // Define new path in Categories folder
      final newPath = 'Categories/$fileName';

      // Copy the image to Categories folder within same bucket
      await bucket.copy(originalImage.fullPath!, newPath);

      // Return new public URL
      return bucket.getPublicUrl(newPath);
    } on StorageException catch (e) {
      throw 'Copy failed: ${e.message}';
    }
  }

  //Register new Category
  Future<void> createCategory() async {
    try {
      //Start loading
      TFullScreenLoader.popUpCircular();

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Validate image selection
      if (selectedImageModel.value == null) {
        throw 'Please select an image for the category';
      }

      // Copy image to Categories folder
      final newImageUrl = await copyImageToCategoryFolder(selectedImageModel.value!);

      //Map Data
      final newRecord = CategoryModel(
        id: '',
        image: newImageUrl,
        name: name.text.trim(),
        createdAt: DateTime.now(),
        isFeatured: isFeatured.value,
        parentId: selectedParent.value.id,
      );

      // Add timeout to prevent hanging
      newRecord.id = await CategoryRepository.instance.createCategory(newRecord).timeout(const Duration(seconds: 10));

      // newRecord.id = await CategoryRepository.instance.createCategory(newRecord);

      //Update all data list
      CategoryController.instance.addItemToLists(newRecord);

      //Reset form
      resetFields();

      //Remove loader
      TFullScreenLoader.stopLoading();

      //Success message & Redirect
      TLoaders.successSnackBar(title: 'Congratulations', message: 'New record has been added');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Pick thumbnail image from media
  // void pickImage() async {
  //   final controller = Get.put(MediaController());
  //   List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

  //   //Handle selected Images
  //   if (selectedImages != null && selectedImages.isNotEmpty) {
  //     //Set the selected image to the main image or perform any other action
  //     ImageModel selectedImage = selectedImages.first;

  //     //Update the main image using the selectedImage
  //     imageURL.value = selectedImage.url;
  //   }
  // }

  // Update pickImage to store ImageModel
  void pickImage() async {
    final controller = MediaController.instance;
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      selectedImageModel.value = selectedImages.first;
      imageURL.value = selectedImages.first.url;
    }
  }

  void resetFields() {
    selectedParent(CategoryModel.empty());
    loading(false);
    isFeatured(false);
    name.clear();
    imageURL.value = '';
  }

 
}
