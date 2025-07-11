import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/constants/text_strings.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final email = Get.parameters['email'] ?? '';
    return Column(
      children: [
        //Header
        Row(
          children: [
            IconButton(onPressed: () => Get.offAllNamed(TRoutes.login), icon: const Icon(CupertinoIcons.clear)),
          ],
        ),

        //Image
        Lottie.asset(TImages.emailLoading, width: 250, height: 250),

        //Title & Subtitle
        Text(
          TTexts.changeYourPasswordTitle,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(email, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(
          TTexts.changeYourPasswordSubTitle,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        //Buttons
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () => Get.offAllNamed(TRoutes.login), child: const Text(TTexts.done)),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        SizedBox(width: double.infinity, child: TextButton(onPressed: () {}, child: const Text(TTexts.resendEmail))),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }
}
