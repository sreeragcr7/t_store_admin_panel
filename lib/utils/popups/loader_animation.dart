import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

///A circular loader widget with customizable foreground & background colors.
class TLoaderAnimation extends StatelessWidget {
  const TLoaderAnimation({super.key, this.height = 200, this.width = 200});

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(TImages.tailLoading, height: height, width: width),
          const SizedBox(height: TSizes.spaceBtwItems),
          const Text('Loading your data...'),
        ],
      ),
    );
  }
}
