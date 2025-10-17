import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/shop/models/banner_model.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/edit_banner/widgets/edit_banner_from.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class EditBannerDesktopScreen extends StatelessWidget {
  const EditBannerDesktopScreen({super.key, required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Breadcrumbs
              TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Update Banner',
                breadscrumbItems: [TRoutes.categories, 'Update Banner'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Form
              EditBannerFrom(banner: banner,),
            ],
          ),
        ),
      ),
    );
  }
}
