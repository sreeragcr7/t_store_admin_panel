import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/shop/models/order_mode.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/order_details.dart/widgets/customer_info.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/order_details.dart/widgets/order_info.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/order_details.dart/widgets/order_items.dart';
import 'package:t_store_admin_panel/features/shop/screens/order/order_details.dart/widgets/order_transaction.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class OrderDetailsDesktopScreen extends StatelessWidget {
  const OrderDetailsDesktopScreen({super.key, required this.order});

  final OrderModel order;

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
                returnToPreviousScreen: true,
                heading: order.id,
                breadscrumbItems: const [TRoutes.orders, 'Details'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Left side Order Information
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        //Order Info
                        OrderInfo(order: order),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Items
                        OrderItems(order: order),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Transactions
                        OrderTransaction(order: order),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),

                  //Right side order Orders
                  Expanded(
                    child: Column(
                      children: [
                        //Customer Info
                        OrderCustomer(order: order),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
