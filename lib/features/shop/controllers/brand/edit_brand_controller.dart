import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class EditBrandController extends GetxController {
  static EditBrandController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BrandRepository());
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;
  // Add variable to store selected image model
  final Rx<ImageModel?> selectedImageModel = Rx<ImageModel?>(null);

  //Init Data
  void init(BrandModel brand) {
    name.text = brand.name;
    imageURL.value = brand.image;
    isFeatured.value = brand.isFeatured;
    if (brand.brandCategories != null) {
      selectedCategories.addAll(brand.brandCategories ?? []);
    }
  }

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

  // Update pickImage to store ImageModel
  void pickImage() async {
    final controller = MediaController.instance;
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      selectedImageModel.value = selectedImages.first;
      imageURL.value = selectedImages.first.url;
    }
  }

  //Register new Brand
  Future<void> updateBrand(BrandModel brand) async {
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

      //Is Data Updated
      bool isBrandUpdated = false;
      if (brand.image != imageURL.value || brand.name != name.text.trim() || brand.isFeatured != isFeatured.value) {
        isBrandUpdated = true;

        //Map Data
        brand.image = imageURL.value;
        brand.name = name.text.trim();
        brand.isFeatured = isFeatured.value;
        brand.updatedAt = DateTime.now();

        //Call Repository to update
        await repository.updateBrand(brand);
      }

      //Update BrandCategories
      if (selectedCategories.isNotEmpty) await updateBrandCategories(brand);

      //Update Brand Data in Products
      if (isBrandUpdated) await updateBrandInProducts(brand);

      //Update All Data List
      BrandController.instance.updateItemFromLists(brand);

      // //Update UI Listeners
      // update();

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Success MEssage & Redirect
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Record has been Updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Update Categories of this Brand
  updateBrandCategories(BrandModel brand) async {
    //Fetch All BrandCategories
    final brandCategories = await repository.getCategoriesOfSpecificBrand(brand.id);

    //SelectedCategoryIds
    final selectedCategoryIds = selectedCategories.map((e) => e.id);

    //Identify categories to remove
    final categoriesToRemove =
        brandCategories
            .where((existingCategory) => !selectedCategoryIds.contains(existingCategory.categoryId))
            .toList();

    //Remove Unselected categories
    for (var categoryToRemove in categoriesToRemove) {
      await BrandRepository.instance.deleteBrandCategory(categoryToRemove.id ?? '');
    }

    //Identify new categories to add
    final newCategoriesToAdd =
        selectedCategories
            .where(
              (newCategory) =>
                  !brandCategories.any((existingCategory) => existingCategory.categoryId == newCategory.id),
            )
            .toList();

    //Add new categories
    for (var newCategory in newCategoriesToAdd) {
      var brandCategory = BrandCategoryModel(brandId: brand.id, categoryId: newCategory.id);
      brandCategory.id = await BrandRepository.instance.createBrandCategory(brandCategory);
    }

    brand.brandCategories!.assignAll(selectedCategories);
    BrandController.instance.updateItemFromLists(brand);
  }
  
  updateBrandInProducts(BrandModel brand) {}
}
