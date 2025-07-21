import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProductTypeWidget extends StatelessWidget {
  const ProductTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Product Type', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: TSizes.spaceBtwItems),

        //Radio button for single Product Type
        RadioMenuButton(
          value: ProductType.single,
          groupValue: ProductType.single,
          onChanged: (value) {},
          child: const Text('Single'),
        ),
        //Radio button for Variable Product Type
        RadioMenuButton(
          value: ProductType.variable,
          groupValue: ProductType.single,
          onChanged: (value) {},
          child: const Text('Variable'),
        ),
      ],
    );
  }
}
