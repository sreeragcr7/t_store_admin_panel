import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';
import 'package:t_store_admin_panel/common/widgets/shimmers/shimmer_effect.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.width = 54,
    this.height = 54,
    this.overlayColor,
    this.memoryImage,
    this.backgroundColor,
    this.image,
    this.imageType = ImageType.asset,
    this.fit = BoxFit.cover,
    this.padding = TSizes.sm,
    this.file
  });

  final BoxFit? fit;
  final String? image;
  final File? file;
  final ImageType imageType;
  final Color? overlayColor;
  final Color? backgroundColor;
  final Uint8List? memoryImage;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        //if image background color is null, then switch it to light & dark mode color design.
        color: backgroundColor ?? (THelperFunctions.isDarkMode(context) ? TColors.black : TColors.white),
        borderRadius: BorderRadius.circular(width >= height ? width : height),
      ),
      child: _buildImageWidget(),
    );
  }


  Widget _buildImageWidget() {
    Widget imageWidget;

    switch (imageType) {
      case ImageType.network:
        imageWidget = _buildNetworkImage();
        break;
      case ImageType.memory:
        imageWidget = _buildMemoryImage();
        break;
      case ImageType.file:
        imageWidget = _buildFileImage();
        break;
      case ImageType.asset:
        imageWidget = _buildAssetImage();
        break;
    }

    //Apply ClipRRect directly to the image widget
    return ClipRRect(
      borderRadius: BorderRadius.circular(width >= height ? width : height), 
      child: imageWidget,
    );
  }

  //Function to build the network image widget
  Widget _buildNetworkImage() {
    if (image != null) {
      //Use CachedNetworkImage for efficient loading & caching of network images //Not working in web but just for loading
      return CachedNetworkImage(
        fit: fit,
        color: overlayColor,
        imageUrl: image!,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        progressIndicatorBuilder: (context, url, downloadProgress) => TShimmerEffect(width: width, height: height),
      );
    } else {
      //Return empty container, if no image is provided.
      return Container();
    }
  }

  //Function to build the memory image widget
  Widget _buildMemoryImage() {
    if (memoryImage != null) {
      //display image from memory image widget
      return Image(fit: fit, image: MemoryImage(memoryImage!), color: overlayColor);
    } else {
      //Return an empty container if no image is provided
      return Container();
    }
  }

  //Function to build the file image widget
  Widget _buildFileImage() {
    if (file != null) {
      //display image from file image widget
      return Image(fit: fit, image: FileImage(file!), color: overlayColor);
    } else {
      //Return an empty container if no image is provided
      return Container();
    }
  }

  //Function to build the asset image widget
  Widget _buildAssetImage() {
    if (image != null) {
      //display image from asset image widget
      return Image(fit: fit, image: AssetImage(image!), color: overlayColor);
    } else {
      //Return an empty container if no image is provided
      return Container();
    }
  }
}

