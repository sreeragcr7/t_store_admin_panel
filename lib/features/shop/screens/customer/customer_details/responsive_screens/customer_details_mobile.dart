import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/authentication/models/user_model.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/customer_details/tables/customer_order_table.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/customer_details/widgets/customer_info.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/customer_details/widgets/shipping_address.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class CustomerDetailsMobileScreen extends StatelessWidget {
  const CustomerDetailsMobileScreen({super.key, required this.customer});

  final UserModel customer;

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
                heading: customer.fullName,
                breadscrumbItems: [TRoutes.customers, 'Details'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Customer Info
              CustomerInfo(customer: customer),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Shipping Address
              const ShippingAddress(),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Left Side Customer Information
              CustomerOrderTable(),
            ],
          ),
        ),
      ),
    );
  }
}
