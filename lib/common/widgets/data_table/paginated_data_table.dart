import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/loaders/animation_loader.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

//Custom PaginatedDataTable with additional features
class TPaginatedDataTable extends StatelessWidget {
  const TPaginatedDataTable({
    super.key,
    required this.columns,
    required this.source,
    this.rowsPerPage = 10,
    this.tableHeight = 550,
    this.onPageChanged,
    this.sortColumnIndex,
    this.dataRowHeight = TSizes.xl * 2,
    this.sortAscending = true,
    this.minWidth = 1000,
  });

  //Weather to start the dataTable in a ascending or descending order.
  final bool sortAscending;

  //Index of the column to sort by
  final int? sortColumnIndex;

  //Number of rows to display per page
  final int rowsPerPage;

  //Data source for the dataTable
  final DataTableSource source;

  //List of columns for the dataTable
  final List<DataColumn> columns;

  //Callback function to handle page change
  final Function(int)? onPageChanged;

  //Height of each data row in the DataTable
  final double dataRowHeight;

  //Height of the entire DataTable
  final double tableHeight;

  //Minimum width of the entire DataTable
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //Set the dynamic height of the PaginatedDataTable
      height: tableHeight,
      child: Theme(
        // Use to set the Backend color
        data: Theme.of(context).copyWith(cardTheme: const CardTheme(color: Colors.white, elevation: 0)),
        child: PaginatedDataTable2(
          source: source,
          columns: columns,
          columnSpacing: 12,
          minWidth: minWidth,
          dividerThickness: 0,
          horizontalMargin: 12,
          rowsPerPage: rowsPerPage,
          dataRowHeight: dataRowHeight,

          //CheckBox Column
          showCheckboxColumn: true,

          //Pagination
          showFirstLastButtons: true,
          onPageChanged: onPageChanged,
          renderEmptyRowsInTheEnd: false,
          onRowsPerPageChanged: (noOfRows) {},

          //Header design
          headingTextStyle: Theme.of(context).textTheme.titleMedium,
          headingRowColor: WidgetStateProperty.resolveWith((states) => TColors.primaryBackground),
          headingRowDecoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(TSizes.borderRadiusMd),
              topRight: Radius.circular(TSizes.borderRadiusMd),
            ),
          ),
          empty: TAnimationLoaderWidget(
            animation: TImages.emailLoading,
            text: 'Nothing Found',
            height: 200,
            width: 200,
          ),

          //Sorting
          sortAscending: sortAscending,
          sortColumnIndex: sortColumnIndex,
          sortArrowBuilder: (bool ascending, bool sorted) {
            if (sorted) {
              return Icon(ascending ? Iconsax.arrow_up_3 : Iconsax.arrow_down, size: TSizes.iconSm);
            } else {
              return const Icon(Iconsax.arrow_up_3, size: TSizes.iconSm);
            }
          },
        ),
      ),
    );
  }
}
