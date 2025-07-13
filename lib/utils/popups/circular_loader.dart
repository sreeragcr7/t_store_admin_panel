import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class TCircularLoader extends StatelessWidget {
  const TCircularLoader({super.key, this.foregroundColor = TColors.white, this.backgroundColor = TColors.primary});

  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.lg),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle), //Circular background
      child: Center(child: CircularProgressIndicator(color: foregroundColor, backgroundColor: Colors.transparent)),
    );
  }
}
