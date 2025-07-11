import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';

class TCircularContainer extends StatelessWidget {
  const TCircularContainer({
    super.key,
    this.child,
    this.margin,
    this.padding,
    this.width = 300,
    this.height = 300,
    this.radius = 300,
    this.showBorder = false,
    this.backgroundColor = TColors.white,
    this.borderColor = TColors.borderPrimary,
  });

  final Widget? child;
  final double? width;
  final double radius;
  final double? height;
  final bool showBorder;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
