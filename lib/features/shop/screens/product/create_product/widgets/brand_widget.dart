import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Brand Label
          Text('Brand', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: TSizes.spaceBtwItems),

          //TypeAheadField for brand selection
          TypeAheadField(
            builder: (context, ctr, focusNode) {
              return TextFormField(
                focusNode: focusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Brand',
                  suffixIcon: Icon(Iconsax.box),
                ),
              );
            },
            suggestionsCallback: (pattern) {
              //Return Filtered brand suggestions based on the search pattern
              return [
                // BrandModel(),
                // BrandModel()
              ];
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion.name));
            },
            onSelected: (suggestion) {},
          ),
        ],
      ),
    );
  }
}
