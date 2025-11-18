import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:t_store_admin_panel/data/repositories/brands/brand_repository.dart';
import 'package:t_store_admin_panel/data/repositories/product/product_repository.dart';
import 'package:t_store_admin_panel/features/shop/controllers/product/product_attribute_controller.dart';
import 'package:t_store_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:t_store_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:t_store_admin_panel/features/shop/controllers/product/product_variation_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/brand_model.dart';
import 'package:t_store_admin_panel/features/shop/models/category_model.dart';
import 'package:t_store_admin_panel/features/shop/models/product_category_model.dart';
import 'package:t_store_admin_panel/features/shop/models/product_model.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class CreateProductController extends GetxController {
  static CreateProductController get instance => Get.find();

  //Observables for loading state and product details
  final isLoading = false.obs;
  final productType = ProductType.single.obs;
  final productVisiblity = ProductVisibility.hidden.obs;

  //Controllers & keys
  final stockPriceFormKey = GlobalKey<FormState>();
  final productRepository = Get.put(ProductRepository());
  final productController = Get.put(ProductController());
  final titleDescriptionFormKey = GlobalKey<FormState>();

  //Text editing controller for input fields
  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();

  //Rx observable for selected brand and categories
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  final RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  //Flags for tracking different tasks
  RxBool thumbnailUploader = false.obs;
  RxBool additionalImagesUploader = false.obs;
  RxBool productDataUploader = false.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  //Function to create a new product
  Future<void> createProduct() async {
    try {
      //Show progress dialogue
      showProgressDialog();

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Validate title & description form
      if (!titleDescriptionFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Validate stock & pricing form if ProductType = Single
      if (productType.value == ProductType.single && !stockPriceFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Ensure a brand is selected
      if (selectedBrand.value == null) throw 'Select Brand for this product';

      //Check variation data if ProductType = Variable
      if (productType.value == ProductType.variable && ProductVariationController.instance.productVariations.isEmpty) {
        throw 'There are no variations for the Product Type variable. Create some variations or change product type.';
      }

      if (productType.value == ProductType.variable) {
        final variationCheckFailed = ProductVariationController.instance.productVariations.any(
          (element) =>
              element.price.isNaN ||
              element.price < 0 ||
              element.salePrice.isNaN ||
              element.salePrice < 0 ||
              element.stock.isNaN ||
              element.stock < 0 ||
              element.image.value.isEmpty,
        );
        if (variationCheckFailed) throw 'Variation data is not accurate. Please recheck variations';
      }

      //Upload product thumbnail image
      thumbnailUploader.value = true;
      final imagesController = ProductImagesController.instance;
      if (imagesController.selectedThumbnailImageUrl.value == null) throw 'Select Product Thumbnail Image';

      //Additional product Images
      additionalImagesUploader.value = true;

      //Product Variation Images
      final variations = ProductVariationController.instance.productVariations;
      if (productType.value == ProductType.single && variations.isNotEmpty) {
        //If admin added variations and then change the Product Type, Remove all variations
        ProductVariationController.instance.resetAllValues();
        variations.value = [];
      }

      //Map product data to ProductModel
      final newRecord = ProductModel(
        id: '',
        sku: '',
        isFeatured: true,
        title: title.text.trim(),
        brand: selectedBrand.value,
        productVariations: variations,
        description: description.text.trim(),
        productType: productType.value.toString(),
        stock: int.tryParse(stock.text.trim()) ?? 0,
        price: double.tryParse(price.text.trim()) ?? 0,
        images: imagesController.additionalProductImagesUrls,
        salePrice: double.tryParse(salePrice.text.trim()) ?? 0,
        thumbnail: imagesController.selectedThumbnailImageUrl.value ?? '',
        productAttributes: ProductAttributeController.instance.productAttributes,
        date: DateTime.now(),
      );

      //Call Repository to Create new Product
      productDataUploader.value = true;
      newRecord.id = await ProductRepository.instance.createProduct(newRecord);

      // Update brand's products count
      if (selectedBrand.value != null) {
        await BrandRepository.instance.incrementBrandProductsCount(selectedBrand.value!.id);
      }

      //Register product categories if any
      if (selectedCategories.isNotEmpty) {
        if (newRecord.id.isEmpty) throw 'Error storing data. Try again';

        //Loop through selected Products Categories
        categoriesRelationshipUploader.value = true;
        for (var category in selectedCategories) {
          //Map Data
          final productCategory = ProductCategoryModel(productId: newRecord.id, categoryId: category.id);
          await ProductRepository.instance.createProductCategory(productCategory);
        }
      }

      //Update product list
      productController.addItemToLists(newRecord);

      //Close the progress loader
      TFullScreenLoader.stopLoading();

      //Show success message loader
      showCompletionDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Reset form values and flags
  void resetValues() {
    isLoading.value = false;
    productType.value = ProductType.single;
    productVisiblity.value = ProductVisibility.hidden;
    stockPriceFormKey.currentState?.reset();
    titleDescriptionFormKey.currentState?.reset();
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    brandTextField.clear();
    selectedBrand.value = null;
    selectedCategories.clear();
    ProductVariationController.instance.resetAllValues();
    ProductAttributeController.instance.resetProductAttributes();

    //Reset Upload Flags
    thumbnailUploader.value = false;
    additionalImagesUploader.value = false;
    productDataUploader.value = false;
    categoriesRelationshipUploader.value = false;
  }

  void showCompletionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Congratulations'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('Go to Products'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(TImages.successtick, height: 200, width: 200),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text('Congratulations', style: Theme.of(Get.context!).textTheme.headlineSmall),
            const SizedBox(height: TSizes.spaceBtwItems),
            const Text('Your Product has been Created'),
          ],
        ),
      ),
    );
  }

  void showProgressDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder:
          (context) => PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Creating Product'),
              content: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(TImages.tailLoading, height: 200, width: 200),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    buildCheckbox('Thumbnail Image', thumbnailUploader),
                    buildCheckbox('Additional Images', additionalImagesUploader),
                    buildCheckbox('Product Data, Attributes & Variations', productDataUploader),
                    buildCheckbox('Product Categories', categoriesRelationshipUploader),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Text('Sit Tight, Your product is uploading'),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  //Check box widget
  Widget buildCheckbox(String label, RxBool value) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 2),
          child:
              value.value
                  ? const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.blue)
                  : const Icon(CupertinoIcons.checkmark_alt_circle),
        ),
        Text(label),
      ],
    );
  }
}
