import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:t_store_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/all_product/table/products_table.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/popups/loader_animation.dart';

class ProductDesktopScreen extends StatelessWidget {
  const ProductDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
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
              Obx(() {
                //Show loader
                if (controller.isLoading.value) return const TLoaderAnimation();
                return TRoundedContainer(
                  child: Column(
                    children: [
                      //Table Header
                      TTableHeader(
                        buttonText: 'Create Product',
                        onPressed: () => Get.toNamed(TRoutes.createProduct),
                        searchOnChanged: (query) => controller.searchQuery(query),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),

                      // Table
                      const ProductsTable(),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
