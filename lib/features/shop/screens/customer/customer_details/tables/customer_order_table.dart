import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:t_store_admin_panel/features/shop/screens/customer/customer_details/tables/table_source.dart';
import 'package:t_store_admin_panel/utils/device/device_utility.dart';

class CustomerOrderTable extends StatelessWidget {
  const CustomerOrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return TPaginatedDataTable(
      minWidth: 550,
      tableHeight: 640,
      dataRowHeight: kMinInteractiveDimension,
      columns: [
        const DataColumn2(label: Text('Order ID')),
        const DataColumn2(label: Text('Date')),
        const DataColumn2(label: Text('Items')),
        DataColumn2(label: const Text('Status'), fixedWidth: TDeviceUtils.isMobileScreen(context) ? 100 : null),
        const DataColumn2(label: Text('Amount'), numeric: true),
      ],
      source: CustomerOrdersRows(),
    );
  }
}
