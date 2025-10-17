import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:t_store_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/all_brand/tables/brands_table.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/popups/loader_animation.dart';

class BrandsMobileScreen extends StatelessWidget {
  const BrandsMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Breadcrumbs
              TBreadcrumbsWithHeading(returnToPreviousScreen: false, heading: 'Brands', breadscrumbItems: ['Brands']),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Table body
              TRoundedContainer(
                child: Column(
                  children: [
                    //Table Header
                    TTableHeader(buttonText: 'Create New Brand', onPressed: () => Get.toNamed(TRoutes.createBrand)),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    //Table
                    Obx(() {
                      //Show loader
                      if (controller.isLoading.value) return const TLoaderAnimation();
                      return const BrandTable();
                    }),
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
