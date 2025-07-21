import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/validators/validation.dart';

class ProductTitleAndDescription extends StatelessWidget {
  const ProductTitleAndDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      child: Form(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Basic Information Text
          Text('Basic Information', style: Theme.of(context).textTheme.headlineSmall,),
          const SizedBox(height: TSizes.spaceBtwItems,),

          //Product Title Input Field
          TextFormField(
            validator: (value) => TValidator.validateEmptyText('Product title', value),
            decoration: const InputDecoration(labelText: 'Product Title'),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields,),

          //Product Description Input Field
          SizedBox(
            height: 300,
            child: TextFormField(
              expands: true, //!imp
              maxLines: null, //!imp
              textAlign: TextAlign.start,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              validator: (value) => TValidator.validateEmptyText('Product Description', value),
              decoration: const InputDecoration(
                labelText: 'Product Description',
                hintText: 'Add your Product Description here...',
                alignLabelWithHint: true,
              ),
            ),
          )

        ],
      )),
    );
  }
}
