import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/data/repositories/category/category_repository.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/category_model.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class EditCategoryController extends GetxController {
  static EditCategoryController get instance => Get.find();

  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
   // Add variable to store selected image model
  final Rx<ImageModel?> selectedImageModel = Rx<ImageModel?>(null);

  //Init Data
  void init(CategoryModel category) {
    name.text = category.name;
    isFeatured.value = category.isFeatured;
    imageURL.value = category.image;

    // Handle parent category safely
    try {
      if (category.parentId.isNotEmpty) {
        final parent = CategoryController.instance.allItems.firstWhere((c) => c.id == category.parentId);
        selectedParent.value = parent;
      } else {
        selectedParent.value = CategoryModel.empty();
      }
    } catch (e) {
      selectedParent.value = CategoryModel.empty();
    }
  }

  //Method to reset fields

  //Pick thumbnail image from media

  //Register new Category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      //Start loading
      TFullScreenLoader.popUpCircular();

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Map data
      category.image = imageURL.value;
      category.name = name.text.trim();
      category.parentId = selectedParent.value.id;
      category.isFeatured = isFeatured.value;
      category.updatedAt = DateTime.now();

      //Call repository to Create New User
      await CategoryRepository.instance.updateCategory(category);

      //Update All Data List
      CategoryController.instance.updateItemFromLists(category);

      //Reset Form
      resetFields();

      //Remove Loder
      TFullScreenLoader.stopLoading();

      //Success Message & Redirect
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your record has been Updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

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
