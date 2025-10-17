import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_store_admin_panel/data/repositories/brands/brand_repository.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/brand_category_model.dart';
import 'package:t_store_admin_panel/features/shop/models/brand_model.dart';
import 'package:t_store_admin_panel/features/shop/models/category_model.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class CreateBrandController extends GetxController {
  static CreateBrandController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;
  // Add variable to store selected image model
  final Rx<ImageModel?> selectedImageModel = Rx<ImageModel?>(null);

  //Toggle category selection
  void toggleSelection(CategoryModel category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  //Method to reset fields
  void resetFields() {
    name.clear();
    loading(false);
    isFeatured(false);
    imageURL.value = '';
    selectedCategories.clear();
  }

  //Pick Thumbnail Image from Media
  void pickImage() async {
    final controller = Get.put(MediaController()); //!
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    //Handle the selected images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      //Set the selected image to the main image or perform any other action
      selectedImageModel.value = selectedImages.first;
      //Update the main image using the selectedImages
      imageURL.value = selectedImages.first.url;
    }
  }

  // Update method to copy images within the same bucket
  Future<String> copyImageToCategoryFolder(ImageModel originalImage) async {
    try {
      final storage = Supabase.instance.client.storage;
      final bucket = storage.from('profile');

      // Extract just the filename from the full path
      final fileName = originalImage.filename;

      // Define new path in Categories folder
      final newPath = 'Brands/$fileName';

      // Copy the image to Categories folder within same bucket
      await bucket.copy(originalImage.fullPath!, newPath);

      // Return new public URL
      return bucket.getPublicUrl(newPath);
    } on StorageException catch (e) {
      throw 'Copy failed: ${e.message}';
    }
  }

  //Register new Brand
  Future<void> createBrand() async {
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

      // Copy image to Brands folder
      final newImageUrl = await copyImageToCategoryFolder(selectedImageModel.value!);

      //Map Data
      final newRecord = BrandModel(
        id: '',
        productsCount: 0,
        image: newImageUrl,
        name: name.text.trim(),
        createdAt: DateTime.now(),
        isFeatured: isFeatured.value,
      );

      //Call Repository to Create New Brand
      newRecord.id = await BrandRepository.instance.createBrand(newRecord).timeout(const Duration(seconds: 10));

      

      //Register Brand categories if any
      if (selectedCategories.isNotEmpty) {
        if (newRecord.id.isEmpty) throw 'Error storing relational data. Try again';

        //Loop selected Brand Categories
        for (var category in selectedCategories) {
          //Map Data
          final brandCategory = BrandCategoryModel(brandId: newRecord.id, categoryId: category.id);
          await BrandRepository.instance.createBrandCategory(brandCategory);
        }

        newRecord.brandCategories ??= [];
        newRecord.brandCategories!.addAll(selectedCategories);
      }

      //Update All Data List
      BrandController.instance.addItemToLists(newRecord);

      //Reset Form
      resetFields();

      //Remove loader
      TFullScreenLoader.stopLoading();

      //Success, Message & Redirect
      TLoaders.successSnackBar(title: 'Congratulations', message: 'New Record has been added.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
