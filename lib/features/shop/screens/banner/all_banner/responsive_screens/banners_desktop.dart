import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/all_banner/tables/banners_table.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class BannersDesktopScreen extends StatelessWidget {
  const BannersDesktopScreen({super.key});

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
              TBreadcrumbsWithHeading(returnToPreviousScreen: false, heading: 'Banners', breadscrumbItems: ['Banners']),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Table body
              TRoundedContainer(
                child: Column(
                  children: [
                    //Table Header
                    TTableHeader(buttonText: 'Create New Banner', onPressed: () => Get.toNamed(TRoutes.createBanner)),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    //Table
                    const BannerTable(),
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
