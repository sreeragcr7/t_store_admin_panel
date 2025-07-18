import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/uploader/image_uploader.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/validators/validation.dart';

class EditCategoryForm extends StatelessWidget {
  const EditCategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      width: 400,
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Heading
            const SizedBox(height: TSizes.sm),
            Text('Update Category', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: TSizes.spaceBtwSections),

            //Name Text Field
            TextFormField(
              validator: (value) => TValidator.validateEmptyText('Name', value),
              decoration: const InputDecoration(labelText: 'Category Name', prefixIcon: Icon(Iconsax.category)),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            DropdownButtonFormField(
              decoration: const InputDecoration(
                hintText: 'Parent Category',
                labelText: 'Parent Category',
                prefixIcon: Icon(Iconsax.bezier),
              ),
              onChanged: (newValue) {},
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('item.name')]),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            TImageUploader(
              width: 80,
              height: 80,
              image: TImages.defaultImageIcon,
              imageType: ImageType.asset,
              onIconButtonPressed: () {},
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            CheckboxMenuButton(value: true, onChanged: (value) {}, child: const Text('Featured')),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Create'))),

            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
