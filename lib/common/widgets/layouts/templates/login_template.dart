import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/styles/t_spacing_style.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';

//Template for login page layout
class TLoginTemplate extends StatelessWidget {
  const TLoginTemplate({super.key, required this.child});

  //The widget to be displayed inside the login template
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Center(
      child: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Container(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              color: dark ? TColors.dark : TColors.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
