import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/shop/models/category_model.dart';
import 'package:t_store_admin_panel/features/shop/screens/category/edit_category/widgets/edit_category_form.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class EditCategoryTabletScreen extends StatelessWidget {
  const EditCategoryTabletScreen({super.key, required this.category});

  final CategoryModel category;

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
                heading: 'Update Category',
                breadscrumbItems: [TRoutes.categories, 'Update Category'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Form
              EditCategoryForm(category: category,),
            ],
          ),
        ),
      ),
    );
  }
}