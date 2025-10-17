import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:t_store_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:t_store_admin_panel/features/shop/controllers/product/create_product_controller.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  

  @override
  Widget build(BuildContext context) {
    //Get instance of CategoryController
    final categoriesController = Get.put(CategoryController());

    //Fetch categories if the list is empty
    if (categoriesController.allItems.isEmpty) {
      categoriesController.fetchItems();
    }

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Categories Label
          Text('Categories', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          //MultiSelectDialogueField for selectiong categories
          Obx(
            () =>
                categoriesController.isLoading.value
                    ? const TShimmerEffect(width: double.infinity, height: 50)
                    : MultiSelectDialogField(
                      buttonText: const Text('Select Categories'),
                      title: const Text('Categories'),
                      items:
                          categoriesController.allItems
                              .map((category) => MultiSelectItem(category, category.name))
                              .toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        CreateProductController.instance.selectedCategories.assignAll(values);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
