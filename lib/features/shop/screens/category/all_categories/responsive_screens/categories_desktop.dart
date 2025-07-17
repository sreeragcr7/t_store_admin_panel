import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:t_store_admin_panel/features/shop/screens/category/all_categories/tables/data_table.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class CategoriesDesktopScreen extends StatelessWidget {
  const CategoriesDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //Breadscrumbs
              const TBreadcrumbsWithHeading(heading: 'Categories', breadscrumbItems: ['Categories']),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Table body
              TRoundedContainer(
                child: Column(
                  children: [
                    //Table Header
                    TTableHeader(
                      buttonText: 'Create New Category',
                      onPressed: () => Get.toNamed(TRoutes.createCategory),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),

                    //Table
                    CategoryTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
