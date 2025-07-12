import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';

///A circular loader widget with customizable foreground & background colors.
class TLoaderAnimation extends StatelessWidget {
  const TLoaderAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(TImages.emailDelivered, height: 200, width: 200));
  }
}
