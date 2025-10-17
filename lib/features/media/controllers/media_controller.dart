import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:t_store_admin_panel/data/repositories/media/media_repository.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/features/media/screens/media/widgets/media_content.dart';
import 'package:t_store_admin_panel/features/media/screens/media/widgets/media_uploader.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/popups/circular_loader.dart';
import 'package:t_store_admin_panel/utils/popups/dialogs.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class MediaController extends GetxController {
  static MediaController get instance => Get.find();

  final RxBool loading = false.obs;

  final int initialLoadCount = 20;
  final int loadMoreCount = 25;

  late DropzoneViewController dropzoneController;
  final RxBool showImagesUploaderSection = false.obs;
  final Rx<MediaCategory> selectedPath = MediaCategory.folders.obs;
  final RxList<ImageModel> selectedImagesToUpload = <ImageModel>[].obs;

  final RxList<ImageModel> allBannerImages = <ImageModel>[].obs;
  final RxList<ImageModel> allProductImages = <ImageModel>[].obs;
  final RxList<ImageModel> allBrandImages = <ImageModel>[].obs;
  final RxList<ImageModel> allCategoryImages = <ImageModel>[].obs;
  final RxList<ImageModel> allUserImages = <ImageModel>[].obs;

  final MediaRepository mediaRepository = MediaRepository();

  ///Get Images
  void getMediaImages() async {
    try {
      loading.value = true;

      RxList<ImageModel> targetList = <ImageModel>[].obs;

      if (selectedPath.value == MediaCategory.banners && allBannerImages.isEmpty) {
        targetList = allBannerImages;
      } else if (selectedPath.value == MediaCategory.brands && allBrandImages.isEmpty) {
        targetList = allBrandImages;
      } else if (selectedPath.value == MediaCategory.categories && allCategoryImages.isEmpty) {
        targetList = allCategoryImages;
      } else if (selectedPath.value == MediaCategory.products && allProductImages.isEmpty) {
        targetList = allProductImages;
      } else if (selectedPath.value == MediaCategory.users && allUserImages.isEmpty) {
        targetList = allUserImages;
      }

      final images = await mediaRepository.fetchImagesFromDatabase(selectedPath.value, initialLoadCount);
      targetList.assignAll(images);

      loading.value = false;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Unable to fetch Images, Something went wrong. Try again');
    }
  }

  ///Load more Images
  void loadMoreMediaImages() async {
    try {
      loading.value = true;

      RxList<ImageModel> targetList = <ImageModel>[].obs;

      if (selectedPath.value == MediaCategory.banners) {
        targetList = allBannerImages;
      } else if (selectedPath.value == MediaCategory.brands) {
        targetList = allBrandImages;
      } else if (selectedPath.value == MediaCategory.categories) {
        targetList = allCategoryImages;
      } else if (selectedPath.value == MediaCategory.products) {
        targetList = allProductImages;
      } else if (selectedPath.value == MediaCategory.users) {
        targetList = allUserImages;
      }

      final images = await mediaRepository.loadMoreImagesFromDatabase(
        selectedPath.value,
        initialLoadCount,
        targetList.last.createdAt ?? DateTime.now(),
      );
      targetList.addAll(images);

      loading.value = false;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Unable to fetch Images, Something went wrong. Try again');
    }
  }

  /// Select Local Images on Button Press
  Future<void> selectLocalImages() async {
    final files = await dropzoneController.pickFiles(multiple: true, mime: ['image/jpeg', 'image/png']);

    if (files.isNotEmpty) {
      for (var file in files) {
        // Retrieve file data as Uint8List
        final bytes = await dropzoneController.getFileData(file);

        // Extract file metadata
        final filename = await dropzoneController.getFilename(file);
        final mimeType = await dropzoneController.getFileMIME(file);

        final image = ImageModel(
          url: '',
          folder: '',
          filename: filename,
          contentType: mimeType,
          localImageToDisplay: Uint8List.fromList(bytes),
        );
        selectedImagesToUpload.add(image);
      }
    }
  }

  ///Popup confirmation to upload Images
  void uploadImageConfirmation() {
    if (selectedPath.value == MediaCategory.folders) {
      TLoaders.warningSnackBar(
        title: 'Select Folder',
        message: 'Please select the folder in the order to upload the Images',
      );
      return;
    }

    TDialogs.defaultDialog(
      context: Get.context!,
      title: 'Upload Images',
      confirmText: 'Upload',
      onConfirm: () async => await uploadImages(),
      content: 'Are you sure you want to upload all the image in ${selectedPath.value.name.toUpperCase()} folder?',
    );
  }

  ///Upload images
  Future<void> uploadImages() async {
    try {
      //Remove confirmation box
      Get.back();

      //Loader
      uploadImagesLoader();

      //Get the selected category
      MediaCategory selectedCategory = selectedPath.value;

      //Get the corresponding list to update
      RxList<ImageModel> targetList;

      //Check the selected category & update the corresponding list
      switch (selectedCategory) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserImages;
          break;
        default:
          return;
      }

      // Upload and add images to the target list
      // Using a reverse loop to avoid 'Concurrent modification during iteration' error
      for (int i = selectedImagesToUpload.length - 1; i >= 0; i--) {
        var selectedImage = selectedImagesToUpload[i];

        // Upload Image to the Storage
        final ImageModel uploadedImage = await mediaRepository.uploadImageFileInStorage(
          fileData: selectedImage.localImageToDisplay!,
          mimeType: selectedImage.contentType!,
          path: getSelectedPath(),
          imageName: selectedImage.filename,
        );

        // Upload Image to the Supabase
        uploadedImage.mediaCategory = selectedCategory.name;
        final id = await mediaRepository.uploadImageFileInDatabase(uploadedImage);

        uploadedImage.id = id;

        selectedImagesToUpload.removeAt(i);
        targetList.add(uploadedImage);
      }

      // Stop Loader after successful upload
      TFullScreenLoader.stopLoading();
    } catch (e) {
      //Stop loader in case of error
      TFullScreenLoader.stopLoading();

      //Show a warning snack-bar for the error
      TLoaders.warningSnackBar(
        title: 'Error Uploading Images',
        message: 'Something went wrong while uploading your images',
      );
    }
  }

  ///Loader to upload Images
  void uploadImagesLoader() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder:
          (context) => PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Uploading Images'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(TImages.uploading, height: 300, width: 300, fit: BoxFit.contain),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const Text('Sit Tight, Your images are uploading...'),
                ],
              ),
            ),
          ),
    );
  }

  ///Get storage path
  String getSelectedPath() {
    // String path = '';
    // switch (selectedPath.value) {
    //   case MediaCategory.banners:
    //     path = TTexts.bannersStoragePath;
    //     break;
    //   case MediaCategory.brands:
    //     path = TTexts.brandsStoragePath;
    //     break;
    //   case MediaCategory.categories:
    //     path = TTexts.categoriesStoragePath;
    //     break;
    //   case MediaCategory.products:
    //     path = TTexts.productsStoragePath;
    //     break;
    //   case MediaCategory.users:
    //     path = TTexts.usersStoragePath;
    //     break;
    //   default:
    //     path = 'Images/Others';
    // }
    // return 'Images/$path';
    return 'Images'; // Only the base Images folder
    // return 'Images/${selectedPath.value.name}';
  }

  //Popup Confirmation to remove cloud image
  void removeCloudImageConfirmation(ImageModel image) {
    //Delete Confirmation
    TDialogs.defaultDialog(
      context: Get.context!,
      content: 'Are you sure you want to delete this image?',
      onConfirm: () {
        //Close the previous Dialog Image Popup
        Get.back();

        removeCloudImage(image);
      },
    );
  }

  ///Remove cloud image
  void removeCloudImage(ImageModel image) async {
    try {
      //Close the removeCloudImageConfirmation() TDialog
      Get.back();

      //Show Loader
      Get.defaultDialog(
        title: '',
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        content: const PopScope(canPop: false, child: SizedBox(width: 150, height: 150, child: TCircularLoader())),
      );
      //Delete image
      await mediaRepository.deleteFileFromStorage(image);

      //Get the corresponding list to update
      RxList<ImageModel> targetList;

      //Check the selected category & update the corresponding list
      switch (selectedPath.value) {
        case MediaCategory.banners:
          targetList = allBannerImages;
          break;
        case MediaCategory.brands:
          targetList = allBrandImages;
          break;
        case MediaCategory.categories:
          targetList = allCategoryImages;
          break;
        case MediaCategory.products:
          targetList = allProductImages;
          break;
        case MediaCategory.users:
          targetList = allUserImages;
          break;
        default:
          return;
      }

      //Remove from the list
      targetList.remove(image);

      update();

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Image Deleted', message: 'Image successfully deleted from your cloud storage');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Images Selection bottom sheet
  Future<List<ImageModel>?> selectImagesFromMedia({
    List<String>? selectedUrls,
    bool allowSelection = true,
    bool multipleSelection = false,
  }) async {
    showImagesUploaderSection.value = true;

    List<ImageModel>? selectedImages = await Get.bottomSheet<List<ImageModel>>(
      isScrollControlled: true,
      backgroundColor: TColors.primaryBackground,
      FractionallySizedBox(
        heightFactor: 1,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                const MediaUploader(),
                MediaContent(
                  allowSelection: allowSelection,
                  alreadySelectedUrls: selectedUrls ?? [],
                  allowMultipleSelection: multipleSelection,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return selectedImages;
  }
  
}
