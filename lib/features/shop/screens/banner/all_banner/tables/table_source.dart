import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:t_store_admin_panel/features/shop/screens/category/all_categories/widgets/table_action_icon_buttons.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class BannersRows extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      cells: [
        const DataCell(
          TRoundedImage(
            width: 180,
            height: 100,
            padding: TSizes.sm,
            image: TImages.banner3,
            imageType: ImageType.asset,
            borderRadius: TSizes.borderRadiusMd,
            backgroundColor: TColors.primaryBackground,
          ),
        ),
        const DataCell(Text('Shop')),
        const DataCell(Icon(Iconsax.eye, color: TColors.primary)),
        DataCell(
          TTableActionButtons(
            onEditPressed: () => Get.toNamed(TRoutes.editBanner, arguments: ''),
            onDeletePressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  //implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  //implement rowCount
  int get rowCount => 10;

  @override
  //implement selectedRowCount
  int get selectedRowCount => 0;
}
