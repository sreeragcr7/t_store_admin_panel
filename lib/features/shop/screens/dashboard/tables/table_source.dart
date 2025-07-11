import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/features/shop/controllers/dashboard/dashboard_controller.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/helpers/helper_functions.dart';

class OrderRows extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    final order = DashboardController.orders[index];
    //implement getRow
    return DataRow2(
      cells: [
        DataCell(Text(order.id, style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: TColors.primary))),
        DataCell(Text(order.formattedOrderDate)),
        const DataCell(Text('5 Items')),
        DataCell(
          TRoundedContainer(
            radius: TSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(vertical: TSizes.xs, horizontal: TSizes.md),
            backgroundColor: THelperFunctions.getOrderStatusColor(order.status).withAlpha(26),
            child: Text(
              order.status.name.capitalize.toString(),
              style: TextStyle(color: THelperFunctions.getOrderStatusColor(order.status)),
            ),
          ),
        ),
        DataCell(Text('\$${order.totalAmount}')),
      ],
    );
  }

  @override
  //implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  //implement rowCount
  int get rowCount => DashboardController.orders.length;

  @override
  //implement selectedRowCount
  int get selectedRowCount => 0;
}
