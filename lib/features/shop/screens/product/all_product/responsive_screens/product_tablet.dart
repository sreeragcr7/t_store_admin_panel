import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/all_product/table/products_table.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProductTabletScreen extends StatelessWidget {
  const ProductTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Breadscrumbs
              TBreadcrumbsWithHeading(
                returnToPreviousScreen: false,
                heading: 'Products',
                breadscrumbItems: ['Products'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Table Body
              TRoundedContainer(
                child: Column(
                  children: [
                    //Table Header
                    TTableHeader(buttonText: 'Add Product', onPressed: () => Get.toNamed(TRoutes.createProduct)),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Table
                    ProductsTable(),
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
