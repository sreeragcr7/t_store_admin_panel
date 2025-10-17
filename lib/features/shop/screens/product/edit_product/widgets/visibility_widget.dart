import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/features/shop/controllers/product/product_visiblity_controller.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProductVisibilityWidget extends StatelessWidget {
  const ProductVisibilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductVisibilityController());

    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Visibility Header
          Text('Visibility', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          //Radio Button for product visibility
          Column(
            children: [
              _buildVisibilityRadioButton(controller, ProductVisibility.published, 'Published'),
              _buildVisibilityRadioButton(controller, ProductVisibility.hidden, 'Hidden'),
            ],
          ),
        ],
      ),
    );
  }

  //Helper Method to build a radio button for product visibility
  Widget _buildVisibilityRadioButton(ProductVisibilityController controller, ProductVisibility value, String label) {
    return Obx(
      () => RadioMenuButton<ProductVisibility>(
        value: value,
        groupValue: controller.selectedVisibility.value,
        onChanged: (selection) {
          controller.setVisibility(selection!);
        },
        child: Text(label),
      ),
    );
  }
}
