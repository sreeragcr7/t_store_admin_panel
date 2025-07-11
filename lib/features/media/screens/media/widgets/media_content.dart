import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/features/media/screens/media/widgets/folder_dropdown.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class MediaContent extends StatelessWidget {
  const MediaContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaController());
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Media images header
          Row(
            children: [
              Text('Select Folder', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(width: TSizes.spaceBtwItems),
              MediaFolderDropdown(
                onChanged: (MediaCategory? newValue) {
                  if (newValue != null) {
                    controller.selectedPath.value = newValue;
                  }
                },
              ),
            ],
          ),
          SizedBox(height: TSizes.spaceBtwSections),

          //Show media
          Wrap(
            alignment: WrapAlignment.start,
            spacing: TSizes.spaceBtwItems / 2,
            runSpacing: TSizes.spaceBtwItems / 2,
            children: [
              TRoundedImage(
                width: 90,
                height: 90,
                padding: TSizes.sm,
                imageType: ImageType.asset,
                image: TImages.applepay,
                // memoryImage: element.localImageToDisplay,
                backgroundColor: TColors.primaryBackground,
              ),
              TRoundedImage(
                width: 90,
                height: 90,
                padding: TSizes.sm,
                imageType: ImageType.asset,
                image: TImages.applepay,
                // memoryImage: element.localImageToDisplay,
                backgroundColor: TColors.primaryBackground,
              ),
              TRoundedImage(
                width: 90,
                height: 90,
                padding: TSizes.sm,
                imageType: ImageType.asset,
                image: TImages.applepay,
                // memoryImage: element.localImageToDisplay,
                backgroundColor: TColors.primaryBackground,
              ),
              TRoundedImage(
                width: 90,
                height: 90,
                padding: TSizes.sm,
                imageType: ImageType.asset,
                image: TImages.applepay,
                // memoryImage: element.localImageToDisplay,
                backgroundColor: TColors.primaryBackground,
              ),
              TRoundedImage(
                width: 90,
                height: 90,
                padding: TSizes.sm,
                imageType: ImageType.asset,
                image: TImages.applepay,
                // memoryImage: element.localImageToDisplay,
                backgroundColor: TColors.primaryBackground,
              ),
              TRoundedImage(
                width: 90,
                height: 90,
                padding: TSizes.sm,
                imageType: ImageType.asset,
                image: TImages.applepay,
                // memoryImage: element.localImageToDisplay,
                backgroundColor: TColors.primaryBackground,
              ),
              TRoundedImage(
                width: 90,
                height: 90,
                padding: TSizes.sm,
                imageType: ImageType.asset,
                image: TImages.applepay,
                // memoryImage: element.localImageToDisplay,
                backgroundColor: TColors.primaryBackground,
              ),
            ],
          ),

          //Load more media button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: TSizes.buttonWidth,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    label: const Text('Load More'),
                    icon: const Icon(Iconsax.arrow_down),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
