import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/data_table/table_header.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/all_orders/tables/order_table.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class OrdersMobileScreen extends StatelessWidget {
  const OrdersMobileScreen({super.key});

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
              const TBreadcrumbsWithHeading(heading: 'Orders', breadscrumbItems: ['Orders']),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Table Body
              TRoundedContainer(
                child: Column(
                  children: [
                    //Table Header
                    TTableHeader(showLeftWidget: false),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    //Table
                    OrderTable(),
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
