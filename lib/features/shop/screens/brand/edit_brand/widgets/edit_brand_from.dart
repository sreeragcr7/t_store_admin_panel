import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/chips/choice_chip.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/uploader/image_uploader.dart';
import 'package:t_store_admin_panel/features/shop/controllers/brand/edit_brand_controller.dart';
import 'package:t_store_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/brand_model.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/validators/validation.dart';

class EditBrandFrom extends StatelessWidget {
  const EditBrandFrom({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBrandController());
    controller.init(brand);
    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Heading
            const SizedBox(height: TSizes.sm),
            Text('Update Brand', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            //Name text Field
            TextFormField(
              controller: controller.name,
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(labelText: 'Brand Name', prefixIcon: Icon(Iconsax.box)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            //Categories
            Text('Select Categories', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Obx(
              () => Wrap(
                spacing: TSizes.sm,
                children:
                    CategoryController.instance.allItems
                        .map(
                          (element) => Padding(
                            padding: const EdgeInsets.only(bottom: TSizes.sm),
                            child: TChoiceChip(
                              text: element.name,
                              selected: controller.selectedCategories.contains(element),
                              onSelected: (value) => controller.toggleSelection(element),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            //Image Uploader & Featured Checkbox
            Obx(
              () => TImageUploader(
                width: 80,
                height: 80,
                image: controller.imageURL.value.isNotEmpty ? controller.imageURL.value : TImages.defaultImageIcon,
                imageType: controller.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                onIconButtonPressed: () => controller.pickImage(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            //Checkbox
            Obx(() => CheckboxMenuButton(
              value: controller.isFeatured.value, 
              onChanged: (value) => controller.isFeatured.value = value ?? false, 
              child: const Text('Featured'))),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            //Button
            SizedBox(width: double.infinity, 
            child: ElevatedButton(onPressed: () => controller.updateBrand(brand), 
            child: const Text('Update'))),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
