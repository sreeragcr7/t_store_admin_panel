import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_circular_image.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class TImageUploader extends StatelessWidget {
  const TImageUploader({
    super.key,
    this.image,
    this.onIconButtonPressed,
    this.memoryImage,
    this.width = 100,
    this.height = 100,
    required this.imageType,
    this.circular = false,
    this.icon = Iconsax.edit_2,
    this.top,
    this.bottom = 0,
    this.right,
    this.left = 0,
  });

  //whether to display the image in a circular shape
  final bool circular;

  //URL or path of the image to display
  final String? image;

  //Type of image (network, asset, memory, etc.)
  final ImageType imageType;

  //Width of the image uploader widget
  final double width;

  //Height of the image uploader widget
  final double height;

  //byte data of the image (for memory images)
  final Uint8List? memoryImage;

  //Icon to display on the image uploader widget
  final IconData icon;

  //Offset from the top edge of the widget
  final double? top;

  //Offset from the bottom edge of the widget
  final double? bottom;

  //Offset from the right edge of the widget
  final double? right;

  //Offset from the left edge of the widget
  final double? left;

  //Callback function for when the icon button is pressed.
  final void Function()? onIconButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Display the image in either circular or rounded shape
        circular
            ? TCircularImage(
              image: image,
              width: width,
              height: height,
              imageType: imageType,
              memoryImage: memoryImage,
              backgroundColor: TColors.primaryBackground,
            )
            : TRoundedImage(
              image: image,
              width: width,
              height: height,
              imageType: imageType,
              memoryImage: memoryImage,
              backgroundColor: TColors.primaryBackground,
            ),

        //Display the edit icon button on the top of the image
        Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: TCircularIcon(
            icon: icon,
            size: TSizes.md,
            color: Colors.white,
            onPressed: onIconButtonPressed,
            backgroundColor: TColors.primary.withAlpha(230),
          ),
        ),
      ],
    );
  }
}
