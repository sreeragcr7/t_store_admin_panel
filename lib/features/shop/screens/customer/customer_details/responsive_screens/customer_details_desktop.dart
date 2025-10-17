import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/personalization/models/user_model.dart';
import 'package:t_store_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';

import 'package:t_store_admin_panel/features/shop/screens/customer/customer_details/widgets/customer_info.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/customer_details/widgets/customer_orders.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/customer_details/widgets/shipping_address.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class CustomerDetailsDesktopScreen extends StatelessWidget {
  const CustomerDetailsDesktopScreen({super.key, required this.customer});

  final UserModel customer;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerDetailController());
    controller.customer.value = customer;
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
                heading: customer.fullName,
                breadscrumbItems: const [TRoutes.customers, 'Details'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Left Side Customer Information
                  Expanded(
                    child: Column(
                      children: [
                        //Customer Info
                        CustomerInfo(customer: customer),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Shipping Address
                        const ShippingAddress(),
                        const SizedBox(height: TSizes.spaceBtwItems),
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwSections),

                  //Left Side Customer Information
                  const Expanded(flex: 2, child: CustomerOrders()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
