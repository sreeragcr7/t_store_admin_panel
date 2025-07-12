import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/device/device_utility.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';
import 'package:clipboard/clipboard.dart';

class ImagePopup extends StatelessWidget {
  //The image model to display detailed info about
  final ImageModel image;

  //Constructor for the ImagePopup class
  const ImagePopup({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        //Define the shape of the dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
        child: TRoundedContainer(
          //Set the width of the rounded container based on the screen size.
          width: TDeviceUtils.isDesktopScreen(context) ? MediaQuery.of(context).size.width * 0.4 : double.infinity,
          padding: const EdgeInsets.all(TSizes.spaceBtwItems),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Display the image with an option to close the dialog.
              SizedBox(
                child: Stack(
                  children: [
                    //Display the image with rounded container
                    TRoundedContainer(
                      backgroundColor: TColors.primaryBackground,
                      child: TRoundedImage(
                        image: image.url,
                        applyImageRadius: true,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width:
                            TDeviceUtils.isDesktopScreen(context)
                                ? MediaQuery.of(context).size.width * 0.4
                                : double.infinity,
                        imageType: ImageType.network,
                      ),
                    ),
                    //Close Icon button positioned at the top-right corner
                    Positioned(
                      top: -4,
                      right: -5,
                      child: IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.close_circle)),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              //Display verisous metadata about the image
              //includes image name, path, type, size, creation & modification dates. and URL
              //Also provide an optin to copy the Image UTL
              Row(
                children: [
                  Expanded(child: Text('Image Name:', style: Theme.of(context).textTheme.bodyLarge)),
                  Expanded(flex: 4, child: Text(image.filename, style: Theme.of(context).textTheme.titleLarge)),
                ],
              ),

              //Display the image URL with an optin to copy it.
              Row(
                children: [
                  Expanded(child: Text('Image URL:', style: Theme.of(context).textTheme.bodyLarge)),
                  Expanded(
                    flex: 4,
                    child: Text(
                      image.url,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: OutlinedButton(
                      onPressed: () {
                        FlutterClipboard.copy(image.url).then((value) => TLoaders.customToast(message: 'URL Copied!'));
                      },
                      child: const Icon(Iconsax.copy),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              //Diaplay a button to delete the image
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Delete Image',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
