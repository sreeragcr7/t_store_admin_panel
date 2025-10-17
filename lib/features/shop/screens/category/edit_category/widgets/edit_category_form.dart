import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/uploader/image_uploader.dart';
import 'package:t_store_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:t_store_admin_panel/features/shop/controllers/category/edit_category_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/category_model.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/validators/validation.dart';

class EditCategoryForm extends StatelessWidget {
  const EditCategoryForm({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditCategoryController());
    editController.init(category);
    // Use Get.find() instead of Get.put() to reuse existing instance
    final categoryController = Get.put(CategoryController());
    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        key: editController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Heading
            const SizedBox(height: TSizes.sm),
            Text('Update Category', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: TSizes.spaceBtwSections),

            //Name Text Field
            TextFormField(
              controller: editController.name,
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(labelText: 'Category Name', prefixIcon: Icon(Iconsax.category)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Obx(() {
              // Explicitly observe reactive variables
              final selectedParent = editController.selectedParent.value;
              final items = categoryController.allItems;

              return DropdownButtonFormField<CategoryModel>(
                decoration: const InputDecoration(
                  hintText: 'Parent Category',
                  labelText: 'Parent Category',
                  prefixIcon: Icon(Iconsax.bezier),
                ),
                value: selectedParent.id.isNotEmpty ? selectedParent : null,
                onChanged: (newValue) => editController.selectedParent.value = newValue!,
                items:
                    items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(item.name), // Display actual category name
                          ),
                        )
                        .toList(),
              );
            }),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            //Image uploader & featured checkbox
            Obx(
              () => TImageUploader(
                width: 80,
                height: 80,
                image:
                    editController.imageURL.value.isNotEmpty ? editController.imageURL.value : TImages.defaultImageIcon,
                imageType: editController.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                onIconButtonPressed: () => editController.pickImage(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Obx(
              () => CheckboxMenuButton(
                value: editController.isFeatured.value,
                onChanged: (value) => editController.isFeatured.value = value ?? false,
                child: const Text('Featured'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => editController.updateCategory(category),
                child: const Text('Update'),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
