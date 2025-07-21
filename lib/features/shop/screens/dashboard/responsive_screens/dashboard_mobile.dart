import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/features/shop/screens/dashboard/tables/dashboard_table.dart';
import 'package:t_store_admin_panel/features/shop/screens/dashboard/widgets/dashboard_card.dart';
import 'package:t_store_admin_panel/features/shop/screens/dashboard/widgets/order_status_pi_graph.dart';
import 'package:t_store_admin_panel/features/shop/screens/dashboard/widgets/weekly_sales.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class DashboardMobileScreen extends StatelessWidget {
  const DashboardMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.softGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Heading
              Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Cards
              TDashboardCard(stats: 25, title: 'Sales total', subTitle: '\$365.6'),
              SizedBox(height: TSizes.spaceBtwItems),
              TDashboardCard(stats: 15, title: 'Average Order Value', subTitle: '\$25'),
              SizedBox(height: TSizes.spaceBtwItems),
              TDashboardCard(stats: 44, title: 'Total Orders', subTitle: '36'),
              SizedBox(height: TSizes.spaceBtwItems),
              TDashboardCard(stats: 2, title: 'Visitors', subTitle: '25,035'),

              const SizedBox(height: TSizes.spaceBtwSections),

              //Bar Graphs
              TWeeklySalesGraph(),
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
              const SizedBox(height: TSizes.spaceBtwItems),

              //Pi Chart
              OrderStatusPiChart(),
            ],
          ),
        ),
      ),
    );
  }
}
