import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/device/device_utility.dart';
import 'package:t_store_admin_panel/utils/validators/validation.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: TColors.primaryBackground),
        const SizedBox(height: TSizes.spaceBtwSections),

        Text('Add Product Attributes', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: TSizes.spaceBtwItems),

        //Form to add new attribute
        Form(
          child:
              TDeviceUtils.isDesktopScreen(context)
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildAttributeName()),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(flex: 2, child: _buildAttributeTextField()),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      _buildAttributeButton(),
                    ],
                  )
                  : Column(
                    children: [
                      _buildAttributeName(),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      _buildAttributeTextField(),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      _buildAttributeButton(),
                    ],
                  ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        //List of added Attributes
        Text('All Attributes', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: TSizes.spaceBtwItems),

        //Display added attributes in rounded container
        TRoundedContainer(
          backgroundColor: TColors.primaryBackground,
          child: Column(children: [buildAttributesList(context), buildEmptyAttributes()]),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        //Generate Variations button
        Center(
          child: SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              icon: const Icon(Iconsax.activity),
              label: const Text('Generate Variations'),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  //Build text form field from attribute name
  TextFormField _buildAttributeName() {
    return TextFormField(
      validator: (value) => TValidator.validateEmptyText('Attribute Name', value),
      decoration: const InputDecoration(labelText: 'Attribute Name', hintText: 'Colors, Sizes, Material'),
    );
  }

  //Build-in button to add a new Attribute
  SizedBox _buildAttributeButton() {
    return SizedBox(
      width: 100,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Iconsax.add),
        label: const Text('Add'),
        style: ElevatedButton.styleFrom(
          foregroundColor: TColors.black,
          backgroundColor: TColors.secondary,
          side: const BorderSide(color: TColors.secondary),
        ),
      ),
    );
  }

  ListView buildAttributesList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
      itemBuilder: (_, index) {
        return Container(
          decoration: BoxDecoration(color: TColors.white, borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
          child: ListTile(
            title: const Text('Color'),
            subtitle: const Text('Green, Orange, Pink'),
            trailing: IconButton(onPressed: () {}, icon: const Icon(Iconsax.trash, color: TColors.error)),
          ),
        );
      },
    );
  }

  Column buildEmptyAttributes() {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedImage(width: 150, height: 80, imageType: ImageType.asset, image: TImages.colorBoxes), //!img
          ],
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Text('There are no attributes added for this product'),
      ],
    );
  }
}

//Build text form field for attribute value
SizedBox _buildAttributeTextField() {
  return SizedBox(
    height: 80,
    child: TextFormField(
      expands: true,
      maxLines: null,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.multiline,
      textAlignVertical: TextAlignVertical.top,
      validator: (value) => TValidator.validateEmptyText('Attribute Field', value),
      decoration: const InputDecoration(
        labelText: 'Attributes',
        hintText: 'Add attributes separated by | Eg: Green | Blue | Yellow',
        alignLabelWithHint: true,
      ),
    ),
  );
}
