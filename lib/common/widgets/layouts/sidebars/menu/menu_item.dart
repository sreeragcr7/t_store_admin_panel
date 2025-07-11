import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/sidebars/sidebar_controller.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class TMenuItem extends StatelessWidget {
  const TMenuItem({super.key, required this.icon, required this.itemName, required this.route});

  final String route;
  final IconData icon;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final menuController = Get.put(SidebarController());

    return InkWell(
      onTap: () => menuController.menuOnTap(route),
      onHover: (hovering) => hovering ? menuController.changeHoverItem(route) : menuController.changeHoverItem(''),
      child: Obx(() {
        final isActive = menuController.isActive(route);
        final isHovering = menuController.isHovering(route);

        // Determine background color
        final bgColor =
            isActive
                ? TColors.primary
                : isHovering
                ? TColors.grey
                : Colors.transparent;

        // Determine icon color
        final iconColor =
            isActive
                ? TColors.white
                : isHovering
                ? TColors.darkerGrey
                : TColors.darkerGrey;

        // Determine text color
        final textColor = isActive ? TColors.white : TColors.darkerGrey;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
          child: Container(
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(TSizes.cardRadiusMd)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: TSizes.lg,
                    top: TSizes.smm,
                    bottom: TSizes.smm,
                    right: TSizes.smm,
                  ),
                  child: Icon(icon, size: 22, color: iconColor),
                ),
                Flexible(child: Text(itemName, style: Theme.of(context).textTheme.bodyMedium!.apply(color: textColor))),
              ],
            ),
          ),
        );
      }),
    );
  }
}
