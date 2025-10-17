import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/images/t_circular_image.dart';
import 'package:t_store_admin_panel/common/widgets/layouts/sidebars/menu/menu_item.dart';
import 'package:t_store_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store_admin_panel/features/personalization/controllers/settings_controller.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthenticationRepository.instance;
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(color: TColors.grey, width: 1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Image
              Row(
                children: [
                  Obx(
                    () => TCircularImage(
                      width: 60,
                      height: 60,
                      padding: 0,
                      margin: EdgeInsets.all(TSizes.md),
                      imageType:
                          SettingsController.instance.settings.value.appLogo.isNotEmpty
                              ? ImageType.network
                              : ImageType.asset,
                      image:
                          SettingsController.instance.settings.value.appLogo.isNotEmpty
                              ? SettingsController.instance.settings.value.appLogo
                              : TImages.darkAppLogo,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => Text(
                        SettingsController.instance.settings.value.appName,
                        style: Theme.of(context).textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('MENU', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),

                    //Menu Item
                    const TMenuItem(route: TRoutes.dashboard, icon: Iconsax.status, itemName: 'Dashboard'),
                    const TMenuItem(route: TRoutes.media, icon: Iconsax.image, itemName: 'Media'),
                    const TMenuItem(route: TRoutes.banners, icon: Iconsax.picture_frame, itemName: 'Banners'),
                    const TMenuItem(route: TRoutes.products, icon: Iconsax.shopping_bag, itemName: 'Products'),
                    const TMenuItem(route: TRoutes.categories, icon: Iconsax.category_2, itemName: 'Categories'),
                    const TMenuItem(route: TRoutes.brands, icon: Iconsax.dcube, itemName: 'Brands'),
                    const TMenuItem(route: TRoutes.customers, icon: Iconsax.profile_2user, itemName: 'Customers'),
                    const TMenuItem(route: TRoutes.orders, icon: Iconsax.box, itemName: 'Orders'),
                    //Other Menu Item
                    Text('OTHER', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                    const TMenuItem(route: TRoutes.profile, icon: Iconsax.user, itemName: 'Profile'),
                    const TMenuItem(route: TRoutes.settings, icon: Iconsax.setting_2, itemName: 'Settings'),
                    ListTile(
                      leading: const Icon(Iconsax.logout, size: 22),
                      onTap: () => _showLogoutConfirmationDialog(context, authRepository),
                      title: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context, AuthenticationRepository authRepository) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                await _performLogout(authRepository);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(AuthenticationRepository authRepository) async {
    try {
      await authRepository.logout();
      // The navigation is handled in the logout() method itself
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
