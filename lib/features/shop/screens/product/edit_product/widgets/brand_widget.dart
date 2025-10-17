import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:t_store_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:t_store_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({super.key});

  @override
  Widget build(BuildContext context) {
    //Get instances of controllers
    final controller = Get.put(EditProductController());
    final brandController = Get.put(BrandController());
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Brand Label
          Text('Brand', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          //TypeAheadField for brand selection
          Obx(
            () =>
                brandController.isLoading.value
                    ? const TShimmerEffect(width: double.infinity, height: 50)
                    : TypeAheadField(
                      builder: (context, ctr, focusNode) {
                        return TextFormField(
                          focusNode: focusNode,
                          controller: controller.brandTextField = ctr,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Select Brand',
                            suffixIcon: Icon(Iconsax.box),
                          ),
                        );
                      },
                      suggestionsCallback: (pattern) {
                        //Return Filtered brand suggestions based on the search pattern
                        return brandController.allItems.where((brand) => brand.name.contains(pattern)).toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(title: Text(suggestion.name));
                      },
                      onSelected: (suggestion) {
                        controller.selectedBrand.value = suggestion;
                        controller.brandTextField.text = suggestion.name;
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
