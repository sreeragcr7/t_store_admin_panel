import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:t_store_admin_panel/features/shop/models/order_mode.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/device/device_utility.dart';

class OrderItems extends StatelessWidget {
  const OrderItems({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    // final subTotal = order.items.fold(0.0, (previousValue, element) => previousValue + (element.price * element.quantity));
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),

          //Items
          ListView.separated(
            shrinkWrap: true,
            itemCount: 5,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(height: TSizes.spaceBtwItems),
            itemBuilder: (_, index) {
              // final item = order.items[index];
              return Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        TRoundedImage(
                          backgroundColor: TColors.primaryBackground,
                          imageType: ImageType.network, //! temporary
                          image: TImages.defaultImageIcon, //! temporary
                          // imageType: item.image != null ? ImageType.network : ImageType.asset,
                          // image: item.image ?? TImages.defaultImageIcon,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // item.title
                                'Title',
                                style: Theme.of(context).textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              // if(item.selectedVersion != null)
                              // Text(item.selectedVersion!.entries.map((e) => ('${e.key} : ${e.value}')).toString())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: TSizes.xl * 2,
                    child: Text(
                      // '\$${item.price.toStringAsFixed(1)}' //! temp
                      'Price',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(
                    width: TDeviceUtils.isMobileScreen(context) ? TSizes.xl * 1.4 : TSizes.xl * 2,
                    child: Text(
                      // '\$${item.quantity.toString()}' //! temp
                      'quantity',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(
                    width: TDeviceUtils.isMobileScreen(context) ? TSizes.xl * 1.4 : TSizes.xl * 2,
                    child: Text(
                      // '\$${item.totalAmount}' //! temp
                      'TotalAmount',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          //Items Total
          TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            backgroundColor: TColors.primaryBackground,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      // '\$$Subtotal',
                      '\$subtotal', //!temp
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '\$0.00', //!temp
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      // '\$${TPricingCalculator.calculateShippingCost(subTotal, '')}',
                      '\$shipping cost', //!temp
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      // '\$${TPricingCalculator.calculateTotalPrice(subTotal, '')}',
                      '\$Total cost', //!temp
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
