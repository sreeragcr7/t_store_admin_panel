import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/chips/choice_chip.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/uploader/image_uploader.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class CreateBrandForm extends StatelessWidget {
  const CreateBrandForm({super.key});

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
            Text('Create New Brands', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwSections),

            //Name text Field
            TextFormField(decoration: const InputDecoration(labelText: 'Brand Name', prefixIcon: Icon(Iconsax.box))),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            //Categories
            Text('Select Categories', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),
            Wrap(
              spacing: TSizes.sm,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: TSizes.sm),
                  child: TChoiceChip(text: 'Shoes', selected: true, onSelected: (value) {}),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: TSizes.sm),
                  child: TChoiceChip(text: 'Track Suits', selected: false, onSelected: (value) {}),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            //Image Uploader & Featured Checkbox
            TImageUploader(
              width: 80,
              height: 80,
              image: TImages.defaultImageIcon,
              imageType: ImageType.asset,
              onIconButtonPressed: () {},
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            //Checkbox
            CheckboxMenuButton(value: true, onChanged: (value) {}, child: const Text('Featured')),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),

            //Button
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Create'))),
            const SizedBox(height: TSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
