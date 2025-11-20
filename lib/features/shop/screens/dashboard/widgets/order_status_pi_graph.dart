import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/common/widgets/icons/t_circular_icon.dart';
import 'package:t_store_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/device/device_utility.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';
import 'package:t_store_admin_panel/utils/popups/loader_animation.dart';

class OrderStatusPiChart extends StatelessWidget {
  const OrderStatusPiChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DashboardController.instance;
    return TRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TCircularIcon(
                icon: Iconsax.status,
                backgroundColor: Colors.amber.withAlpha(26),
                color: Colors.amber,
                size: TSizes.md,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text('Orders Status', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections / 2),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Pi-Graph
              Obx(
                () =>
                    controller.orderStatusData.isNotEmpty
                        ? SizedBox(
                          height: 270,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: TDeviceUtils.isTabletScreen(context) ? 70 : 40,
                              startDegreeOffset: 180,
                              sections:
                                  controller.orderStatusData.entries.map((entry) {
                                    final OrderStatus status = entry.key;
                                    final int count = entry.value;

                                    return PieChartSectionData(
                                      showTitle: true,
                                      color: THelperFunctions.getOrderStatusColor(status),
                                      value: count.toDouble(),
                                      title: '$count',
                                      radius: TDeviceUtils.isTabletScreen(context) ? 80 : 100,
                                      titleStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  }).toList(),
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                  //Handle touch events here if needed
                                },
                                enabled: true,
                              ),
                            ),
                          ),
                        )
                        : const SizedBox(
                          height: 400,
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [TLoaderAnimation()]),
                        ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems / 2),

              //Show Status & Color Meta
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => DataTable(
                    columns: const [
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Orders')),
                      DataColumn(label: Text('Total')),
                    ],
                    rows:
                        controller.orderStatusData.entries.map((entry) {
                          final OrderStatus status = entry.key;
                          final int count = entry.value;
                          final double totalAmount = controller.totalAmounts[status]!;
                          final String displayStatus = controller.getDisplayStatusName(status);

                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    TCircularContainer(
                                      width: 20,
                                      height: 20,
                                      backgroundColor: THelperFunctions.getOrderStatusColor(status),
                                    ),
                                    const SizedBox(width: TSizes.sm),
                                    Expanded(child: Text(' $displayStatus')),
                                  ],
                                ),
                              ),
                              DataCell(Text(count.toString())),
                              DataCell(Text('\$${totalAmount.toStringAsFixed(2)}')), //fromat as needed
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
