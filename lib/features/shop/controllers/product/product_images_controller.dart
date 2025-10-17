import 'package:get/get.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/features/shop/models/product_variation_model.dart';

class ProductImagesController extends GetxController {
  //Singleton inatance
  static ProductImagesController get instance => Get.find();

  //Rx obs for selected thumbnail image
  Rx<String?> selectedThumbnailImageUrl = Rx<String?>(null);

  //Lists to store additional product images
  final RxList<String> additionalProductImagesUrls = <String>[].obs;

  //Function to remove Product Image
  Future<void> removeImage(int index) async {
    additionalProductImagesUrls.removeAt(index);
  }

  //Pick Thumbnail Image from media
  void selectedThumbnailImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    //Handle the selected Images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      //Set the selected image to the main image or perform any other action
      ImageModel selectedImage = selectedImages.first;

      //Update the main image using the selectedImage
      selectedThumbnailImageUrl.value = selectedImage.url;
    }
  }

  //Pick thumbnail image from media
  void selectVariationImage(ProductVariationModel variation) async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    //Handle the selected Images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      //Set the selected image to the main image or perform any other action
      ImageModel selectedImage = selectedImages.first;

      //Update the main image using the selectedImage
      variation.image.value = selectedImage.url;
    }
  }

  //Pick Multiple Images from media
  void selectMultipleProductImages() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia(
      multipleSelection: true,
      selectedUrls: additionalProductImagesUrls,
    );

    //Handle the selected Images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      additionalProductImagesUrls.assignAll(selectedImages.map((e) => e.url));
    }
  }
}
