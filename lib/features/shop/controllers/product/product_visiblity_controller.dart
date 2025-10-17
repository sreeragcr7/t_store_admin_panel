// controllers/product_visibility_controller.dart
import 'package:get/get.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';

class ProductVisibilityController extends GetxController {
  var selectedVisibility = ProductVisibility.published.obs;
  
  void setVisibility(ProductVisibility visibility) {
    selectedVisibility.value = visibility;
  }
}  