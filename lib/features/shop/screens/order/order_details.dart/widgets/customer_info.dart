import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:t_store_admin_panel/features/shop/controllers/order/order_detail_controller.dart';
import 'package:t_store_admin_panel/features/shop/models/order_mode.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class OrderCustomer extends StatelessWidget {
  const OrderCustomer({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailController());
    controller.order.value = order;
    controller.getCustomerOfCurrentOrder();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Persona Info
        TRoundedContainer(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),
              Obx(() {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final customer = controller.customer.value;

                return Row(
                  children: [
                    TRoundedImage(
                      padding: 0,
                      backgroundColor: TColors.primaryBackground,
                      image: customer.profilePicture.isNotEmpty ? customer.profilePicture : TImages.user,
                      imageType: customer.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.fullName,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(customer.email, overflow: TextOverflow.ellipsis, maxLines: 1),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        //Contact Info
        Obx(() {
          if (controller.loading.value) {
            return TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final customer = controller.customer.value;
          return SizedBox(
            width: double.infinity,
            child: TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Person', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Text(customer.fullName, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(customer.email, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(
                    customer.formattedPhoneNo.isNotEmpty ? customer.formattedPhoneNo : '(+1) *** ****',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: TSizes.spaceBtwSections),

        //Contact Info
        SizedBox(
          width: double.infinity,
          child: TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shipping Address', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: TSizes.spaceBtwSections),
                if (order.shippingAddress != null && order.shippingAddress!.name.isNotEmpty) ...[
                  Text(order.shippingAddress!.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(order.shippingAddress!.toString(), style: Theme.of(context).textTheme.titleMedium),
                ] else ...[
                  Text(
                    'No shipping address',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: TColors.darkerGrey),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),

        // Billing Address
        SizedBox(
          width: double.infinity,
          child: TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Billing Address', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: TSizes.spaceBtwSections),
                if (order.billingAddress != null && order.billingAddress!.name.isNotEmpty) ...[
                  Text(order.billingAddress!.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(order.billingAddress!.toString(), style: Theme.of(context).textTheme.titleMedium),
                ] else if (order.shippingAddress != null && order.shippingAddress!.name.isNotEmpty) ...[
                  Text(
                    'Same as shipping address',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: TColors.darkerGrey),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Text(order.shippingAddress!.toString(), style: Theme.of(context).textTheme.titleMedium),
                ] else ...[
                  Text(
                    'No billing address',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: TColors.darkerGrey),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }
}
