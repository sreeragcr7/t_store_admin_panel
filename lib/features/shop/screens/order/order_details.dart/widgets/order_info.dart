import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/features/shop/models/order_mode.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/device/device_utility.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Information', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    Text(order.formattedOrderDate, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [const Text('Items'), Text('${order} Items', style: Theme.of(context).textTheme.bodyLarge)],
                ),
              ),
              Expanded(
                flex: TDeviceUtils.isMobileScreen(context) ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status'),
                    TRoundedContainer(
                      radius: TSizes.cardRadiusSm,
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: 0),
                      backgroundColor: THelperFunctions.getOrderStatusColor(OrderStatus.pending).withAlpha(26),
                      child: DropdownButton<OrderStatus>(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        value: OrderStatus.pending,
                        onChanged: (OrderStatus? newValue) {},
                        items:
                            OrderStatus.values.map((OrderStatus status) {
                              return DropdownMenuItem<OrderStatus>(
                                value: status,
                                child: Text(
                                  status.name.capitalize.toString(),
                                  style: TextStyle(color: THelperFunctions.getOrderStatusColor(OrderStatus.pending)),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
