import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';

class TCircularIcon extends StatelessWidget {
  //A custom circular Icon widget with a background color.
  //Properties are:
  //Container [width], [height], & [backgroundColor].
  //Icon's [size], [color] & [onPressed]
  const TCircularIcon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.size = TSizes.lg,
    this.onPressed,
    this.color,
    this.backgroundColor,
  });

  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:
            backgroundColor != null
                ? backgroundColor!
                : dark
                ? TColors.black.withAlpha(225)
                : TColors.white.withAlpha(225),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: size),
        alignment: Alignment.center, // not in tut
        padding: EdgeInsets.zero,
      ),
    );
  }
}
