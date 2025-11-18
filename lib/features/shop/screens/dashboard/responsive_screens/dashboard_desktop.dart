import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:t_store_admin_panel/features/shop/screens/dashboard/tables/dashboard_table.dart';

import 'package:t_store_admin_panel/features/shop/screens/dashboard/widgets/dashboard_card.dart';
import 'package:t_store_admin_panel/features/shop/screens/dashboard/widgets/order_status_pi_graph.dart';
import 'package:t_store_admin_panel/features/shop/screens/dashboard/widgets/weekly_sales.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class DashboardDesktopScreen extends StatelessWidget {
  const DashboardDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return Scaffold(
      backgroundColor: TColors.softGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Heading
              Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Cards
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.note,
                        headingIconColor: Colors.blue,
                        headingIconBgColor: Colors.blue.withAlpha(26),
                        context: context,
                        stats: 25,
                        title: 'Sales total',
                        subTitle:
                            '\$${controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.external_drive,
                        headingIconColor: Colors.green,
                        headingIconBgColor: Colors.green.withAlpha(26),
                        context: context,
                        stats: 15,
                        title: 'Average Order Value',
                        subTitle:
                            '\$${(controller.orderController.allItems.fold(0.0, (previousValue, element) => previousValue + element.totalAmount) / controller.orderController.allItems.length).toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.box,
                        headingIconColor: Colors.deepPurple,
                        headingIconBgColor: Colors.deepPurple.withAlpha(26),
                        context: context,
                        icon: Iconsax.box,
                        color: Colors.deepPurple,
                        stats: 44,
                        title: 'Total Orders',
                        subTitle: '\$${controller.orderController.allItems.length}',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Obx(
                      () => TDashboardCard(
                        headingIcon: Iconsax.user,
                        headingIconColor: Colors.deepOrange,
                        headingIconBgColor: Colors.deepOrange.withAlpha(26),
                        context: context,
                        stats: 2,
                        title: 'Visitors',
                        subTitle: controller.customerController.allItems.length.toString(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Graphs
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        //Bar Graph
                        const TWeeklySalesGraph(),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        //Orders
                        TRoundedContainer(
                          child: Column(
                            children: [
                              Text('Recent Orders', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwSections),
                              const DashboardOrderTable(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  //Pi Chart
                  Expanded(child: OrderStatusPiChart()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
