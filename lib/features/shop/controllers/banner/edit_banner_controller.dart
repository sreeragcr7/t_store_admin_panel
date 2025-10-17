import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/data/repositories/banner/banner_repository.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/banner_model.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class EditBannerController extends GetxController {
  static EditBannerController get intance => Get.find();

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final targetScreen = ''.obs;
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BannerRepository());
  final Rx<ImageModel?> selectedImageModel = Rx<ImageModel?>(null);

  //Init data
  void init(BannerModel banner) {
    imageURL.value = banner.imageUrl;
    isActive.value = banner.active;
    targetScreen.value = banner.targetScreen;
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

  //Register new banner
  Future<void> updateBenner(BannerModel banner) async {
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

      //Is Data Updated
      if (banner.imageUrl != imageURL.value ||
          banner.targetScreen != targetScreen.value ||
          banner.active != isActive.value) {
        banner.imageUrl = imageURL.value;
        banner.targetScreen = targetScreen.value;
        banner.active = isActive.value;

        //Call Repository to Update
        await repository.updateBanner(banner);
      }

      //Update the list
      BannerController.instance.updateItemFromLists(banner);

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Success MEssage & Redirect
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Record has been Updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
