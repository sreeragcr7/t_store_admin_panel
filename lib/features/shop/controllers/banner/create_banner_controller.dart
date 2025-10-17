import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_store_admin_panel/data/repositories/banner/banner_repository.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/banner_model.dart';
import 'package:t_store_admin_panel/routes/app_screen.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class CreateBannerController extends GetxController {
  static CreateBannerController get instance => Get.find();

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final RxString targetScreen = AppScreen.allAppScreenItems[0].obs;
  final formKey = GlobalKey<FormState>();
  final Rx<ImageModel?> selectedImageModel = Rx<ImageModel?>(null);

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
      final newPath = 'Banners/$fileName';

      // Copy the image to Categories folder within same bucket
      await bucket.copy(originalImage.fullPath!, newPath);

      // Return new public URL
      return bucket.getPublicUrl(newPath);
    } on StorageException catch (e) {
      throw 'Copy failed: ${e.message}';
    }
  }

  Future<void> createBanner() async {
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

      // Copy image to Banners folder
      final newImageUrl = await copyImageToCategoryFolder(selectedImageModel.value!);

      //Map Data
      final newRecord = BannerModel(
        id: '',
        active: isActive.value,
        imageUrl: newImageUrl,
        targetScreen: targetScreen.value,
      );

      //Call Repository to create New Baner and Update ID
      newRecord.id = await BannerRepository.instance.createBanner(newRecord).timeout(const Duration(seconds: 10));

      //Update all data List
      BannerController.instance.addItemToLists(newRecord);

      //Remove Loader
      TFullScreenLoader.stopLoading();

      //Success Message & Redirect
      TLoaders.successSnackBar(title: 'Congratulations', message: 'New record has been added');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
