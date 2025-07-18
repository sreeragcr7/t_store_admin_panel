import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/shop/screens/category/create_category/widgets/create_category_form.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class CreateCategoryMobileScreen extends StatelessWidget {
  const CreateCategoryMobileScreen({super.key});

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
                heading: 'Create Category',
                breadscrumbItems: [TRoutes.categories, 'Create Category'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Form
              CreateCategoryForm()
            ],
          ),
        ),
      ),
    );
  }
}
