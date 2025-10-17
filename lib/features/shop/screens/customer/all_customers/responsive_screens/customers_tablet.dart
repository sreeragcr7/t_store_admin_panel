import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:t_store_admin_panel/features/shop/controllers/customer/customer_controller.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/all_customers/tables/customer_table.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/popups/loader_animation.dart';

class CustomersTabletScreen extends StatelessWidget {
  const CustomersTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Breadscrumbs
              const TBreadcrumbsWithHeading(heading: 'Customers', breadscrumbItems: ['Customers']),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              TRoundedContainer(
                child: Column(
                  children: [
                    //Table Header
                    TTableHeader(
                      showLeftWidget: false,
                      searchController: controller.searchTextController,
                      searchOnChanged: (query) => controller.searchQuery(query),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    //Table
                    Obx(() {
                      //Show loader
                      if (controller.isLoading.value) return const TLoaderAnimation();
                      return const CustomerTable();
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
