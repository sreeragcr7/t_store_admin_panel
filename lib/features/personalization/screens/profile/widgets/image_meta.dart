import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/uploader/image_uploader.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ImageAndMeta extends StatelessWidget {
  const ImageAndMeta({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.symmetric(vertical: TSizes.lg, horizontal: TSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              //User Image
              const TImageUploader(
                right: 10,
                bottom: 20,
                left: null,
                width: 150,
                height: 150,
                circular: true,
                icon: Iconsax.camera,
                imageType: ImageType.asset,
                image: TImages.user,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text('Arun K', style: Theme.of(context).textTheme.headlineMedium),
              const Text('arun@gmail.com'),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ],
      ),
    );
  }
}
