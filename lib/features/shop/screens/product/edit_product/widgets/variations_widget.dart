import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:t_store_admin_panel/common/widgets/uploader/image_uploader.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProductVariations extends StatelessWidget {
  const ProductVariations({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Product Variations Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Product Variations', style: Theme.of(context).textTheme.headlineMedium),
              TextButton(onPressed: () {}, child: const Text('Remove Variations')),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          //Variations List
          ListView.separated(
            itemCount: 2,
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (_, index) {
              return _buildVariationTile();
            },
          ),

          //No Veriation Message
          _buildNoVariationsMessage(),
        ],
      ),
    );
  }

  //Helper method to build a variation tile
  Widget _buildVariationTile() {
    return ExpansionTile(
      backgroundColor: TColors.lightGrey,
      collapsedBackgroundColor: TColors.lightGrey,
      childrenPadding: const EdgeInsets.all(TSizes.md),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
      title: const Text('Color: Green, Sizes: Small'),
      children: [
        //Upload Variation Image
        Obx(
          () => TImageUploader(
            right: 0,
            left: null,
            imageType: ImageType.asset,
            image: TImages.defaultImageIcon, //!img
            onIconButtonPressed: () {},
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        //Variations Stock & Pricing
        Row(
          children: [
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Stock', hintText: 'Add Stock, Only numbers are allowed'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Expanded(
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$'))],
                decoration: const InputDecoration(labelText: 'Price', hintText: 'Price with up-to 2 decimals'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            Expanded(
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$'))],
                decoration: const InputDecoration(
                  labelText: 'Discounted Price',
                  hintText: 'Price with up-to 2 decimals',
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            //Variation Description
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Discounted Price',
                hintText: 'Add description of this veriation...',
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ],
    );
  }

  //Helper method to build message when there are no veriations
  Widget _buildNoVariationsMessage() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TRoundedImage(width: 200, height: 200, imageType: ImageType.asset, image: TImages.emptyBox), //!img
          ],
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        Text('There are no veriations added for this product'),
      ],
    );
  }
}
