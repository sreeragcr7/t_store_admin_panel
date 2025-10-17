import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/data/repositories/product/product_repository.dart';
import 'package:t_store_admin_panel/features/shop/controllers/category/category_controller.dart';
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

class EditProductController extends GetxController {
  static EditProductController get instance => Get.find();

  //Observables for loading state and product details
  final isLoading = false.obs;
  final selectedCategoriesLoader = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;

  //Controllers & keys
  final variationsController = Get.put(ProductVariationController());
  final attributesController = Get.put(ProductAttributeController());
  final imagesController = Get.put(ProductImagesController());
  final productRepository = Get.put(ProductRepository());
  final stockPriceFormKey = GlobalKey<FormState>();
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
  final List<CategoryModel> alreadyAddedCategories = <CategoryModel>[];

  //Flags for tracking different tasks
  RxBool thumbnailUploader = true.obs;
  RxBool productDataUploader = false.obs;
  RxBool additionalImagesUploader = true.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  //Initialize Product Data
  void initProductData(ProductModel product) {
    try {
      isLoading.value = true; //Set loding state while initializing data

      //Basic Information
      title.text = product.title;
      description.text = product.description ?? '';
      productType.value =
          product.productType == ProductType.single.toString() ? ProductType.single : ProductType.variable;

      //Stock & Pricing (assuming productType & productVisiblity are handled elsewhere)
      if (product.productType == ProductType.single.toString()) {
        stock.text = product.stock.toString();
        price.text = product.price.toString();
        salePrice.text = product.salePrice.toString();
      }

      //Product Brand
      selectedBrand.value = product.brand;
      brandTextField.text = product.brand?.name ?? '';

      //Product Thumbnail and Images
      if (product.images != null) {
        //Set the first image as the thumbnail
        imagesController.selectedThumbnailImageUrl.value = product.thumbnail;

        //Add the images to additionalProductImagesUrl
        imagesController.additionalProductImagesUrls.assignAll(product.images ?? []);
      }

      //Product Attributes & Variations (assuming you have a method to fetch variations in ProductVariationController)
      attributesController.productAttributes.assignAll(product.productAttributes ?? []);
      variationsController.productVariations.assignAll(product.productVariations ?? []);
      variationsController.initializeVariationControllers(product.productVariations ?? []);

      isLoading.value = false; //Set loading state back to false after initialization

      update();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<List<CategoryModel>> loadSelectedCategories(String productId) async {
    selectedCategoriesLoader.value = true;
    //Product Categories
    final productCategories = await productRepository.getProductCategories(productId);
    final categoriesController = Get.put(CategoryController());
    if (categoriesController.allItems.isEmpty) await categoriesController.fetchItems();

    final categoriesIds = productCategories.map((e) => e.categoryId).toList();
    final categories = categoriesController.allItems.where((element) => categoriesIds.contains(element.id)).toList();
    selectedCategories.assignAll(categories);
    selectedCategoriesLoader.value = false;
    return categories;
  }

  //Function to create a new product
  Future<void> editProduct(ProductModel product) async {
    try {
      //Show progress dialogue
      showProgressDialog();

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (isConnected) {
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
      final imagesController = ProductImagesController.instance;
      // thumbnailUploader.value = true;
      if (imagesController.selectedThumbnailImageUrl.value == null ||
          imagesController.selectedThumbnailImageUrl.value!.isEmpty) {
        throw 'Upload Product Thumbnail Image';
      }
      // //Additional product Images
      // additionalImagesUploader.value = true;

      //Upload Product Variation Images if  any
      var variations = ProductVariationController.instance.productVariations;
      if (productType.value == ProductType.single && variations.isNotEmpty) {
        //If admin added variations and then change the Product Type, Remove all variations
        ProductVariationController.instance.resetAllValues();
        variations.value = [];
      }

      product.sku = '';
      product.isFeatured = true;
      product.title = title.text.trim();
      product.brand = selectedBrand.value;
      product.productVariations = variations;
      product.description = description.text.trim();
      product.productType = productType.value.toString();
      product.stock = int.tryParse(stock.text.trim()) ?? 0;
      product.price = double.tryParse(stock.text.trim()) ?? 0;
      product.images = imagesController.additionalProductImagesUrls;
      product.salePrice = double.tryParse(salePrice.text.trim()) ?? 0;
      product.thumbnail = imagesController.selectedThumbnailImageUrl.value ?? '';
      product.productAttributes = ProductAttributeController.instance.productAttributes;
      // date: DateTime.now(),

      //Call Repository to Update new Product
      productDataUploader.value = true;
      await ProductRepository.instance.updateProduct(product);

      //Register product categories if any
      if (selectedCategories.isNotEmpty) {
        //Loop through selected Products Categories
        categoriesRelationshipUploader.value = true;

        //Get the existing category IDs
        List<String> existingCategoryIds = alreadyAddedCategories.map((category) => category.id).toList();

        for (var category in selectedCategories) {
          //Check if category is not alredy associated with the product
          if (!existingCategoryIds.contains(category.id)) {
            //Map Data
            final productCategory = ProductCategoryModel(productId: product.id, categoryId: category.id);
            await ProductRepository.instance.createProductCategory(productCategory);
          }
        }

        //Remove categories not selected by the user'
        for (var existingCategoryId in existingCategoryIds) {
          //Check if the category is not present in the selected categories
          if (!selectedCategories.any((category) => category.id == existingCategoryId)) {
            //Remove the association
            await ProductRepository.instance.removeProductCategory(product.id, existingCategoryId);
          }
        }
      }

      //Update product list
      ProductController.instance.updateItemFromLists(product);

      //Close the progress loader
      TFullScreenLoader.stopLoading();

      //Show success message loader
      showCompletionDialog();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
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
            Image.asset(TImages.successtick2, height: 200, width: 200),
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
                    Image.asset(TImages.emailLoading, height: 200, width: 200),
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
