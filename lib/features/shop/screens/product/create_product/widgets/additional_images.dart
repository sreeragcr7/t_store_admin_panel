import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProductAdditionalImages extends StatelessWidget {
  const ProductAdditionalImages({
    super.key,
    required this.additionalProductImagesURLs,
    this.onTapToAddImages,
    this.onTapToRemoveImages,
  });

  final RxList<String> additionalProductImagesURLs;
  final void Function()? onTapToAddImages;
  final void Function(int index)? onTapToRemoveImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          //Section to Add Additional Product Images
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: onTapToAddImages,
              child: TRoundedContainer(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(TImages.defaultImageIcon, width: 50, height: 50),
                      const Text('Add Additional Product Images'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Section to display Uploaded Images
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 2, child: SizedBox(height: 80, child: _uploadImagesOrEmptyList())),
                const SizedBox(width: TSizes.spaceBtwItems / 2),

                //Add More Images Button
                TRoundedContainer(
                  width: 80,
                  height: 80,
                  showBorder: true,
                  borderColor: TColors.grey,
                  backgroundColor: TColors.white,
                  onTap: onTapToAddImages,
                  child: const Center(child: Icon(Iconsax.add)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Widgets to display Either Uploaded Images or Empty List
  Widget _uploadImagesOrEmptyList() {
    // additionalProductImagesURLs.isNotEmpty ? _uploadedImages() :
    return emptyList();
  }

  //Widgets to display Empty List holder
  Widget emptyList() {
    return ListView.separated(
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: TSizes.spaceBtwItems / 2),
      itemBuilder:
          (context, index) =>
              const TRoundedContainer(backgroundColor: TColors.primaryBackground, width: 80, height: 80),
    );
  }

  //Widgets to diaplay Uploaded Images
  // ListView _uploadedImages() {
  //   return ListView.separated(
  //     scrollDirection: Axis.horizontal,
  //     itemCount: additionalProductImagesURLs.length,
  //     separatorBuilder: (context, index) => const SizedBox(width: TSizes.spaceBtwItems / 2),
  //     itemBuilder: (context, index) {
  //       final image = additionalProductImagesURLs[index];
  //       return TImageUploader(
  //         top: 0,
  //         right: 0,
  //         width: 80,
  //         height: 80,
  //         left: null,
  //         image: image,
  //         icon: Iconsax.close_circle,
  //         imageType: ImageType.network,
  //         onIconButtonPressed: () => onTapToRemoveImages!(index),
  //       );
  //     },
  //   );
  // }
}
