import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/shop/models/brand_model.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/edit_brand/widgets/edit_brand_from.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class EditBrandMobileScreen extends StatelessWidget {
  const EditBrandMobileScreen({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Breadcrumbs
              TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Update Brand',
                breadscrumbItems: [TRoutes.categories, 'Update Brand'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Form
              EditBrandFrom(brand: brand,),
            ],
          ),
        ),
      ),
    );
  }
}
