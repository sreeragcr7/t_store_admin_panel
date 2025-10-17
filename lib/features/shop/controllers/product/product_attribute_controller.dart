import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/features/shop/controllers/product/product_variation_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:t_store_admin_panel/utils/popups/dialogs.dart';

class ProductAttributeController extends GetxController {
  static ProductAttributeController get instance => Get.find();

  //Observable for loading state, form key, & product attributes
  final isLoading = false.obs;
  final attributesFormKey = GlobalKey<FormState>();
  TextEditingController attributeName = TextEditingController();
  TextEditingController attributes = TextEditingController();
  final RxList<ProductAttributeModel> productAttributes = <ProductAttributeModel>[].obs;

  //Function to add a new Attribute
  void addNewAttribute() {
    //Form validation
    if (!attributesFormKey.currentState!.validate()) {
      return;
    }

    //Add attribute to the List of Attributes
    productAttributes.add(
      ProductAttributeModel(name: attributeName.text.trim(), values: attributes.text.trim().split('|').toList()),
    );

    //Clear text fields aftetr adding
    attributeName.text = '';
    attributes.text = '';
  }

  //Function to remove an attribute
  void removeAttribute(int index, BuildContext context) {
    //Show a confirmation dialog
    TDialogs.defaultDialog(
      context: context,
      onConfirm: () {
        //User confirmed, remove the attribute
        Navigator.of(context).pop();
        productAttributes.removeAt(index);

        //Reset productVariations when removing an attribute
        ProductVariationController.instance.productVariations.value = [];
      },
    );
  }

  //Function to reset productAttributes
  void resetProductAttributes() {
    productAttributes.clear();
  }
}
