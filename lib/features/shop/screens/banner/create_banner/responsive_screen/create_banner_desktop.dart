import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/shop/screens/banner/create_banner/widgets/create_banner_form.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class CreateBannerDesktopScreen extends StatelessWidget {
  const CreateBannerDesktopScreen({super.key});

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
                heading: 'Create Banner',
                breadscrumbItems: [TRoutes.banners, 'Create Banner'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Form
              CreateBannerForm(),
            ],
          ),
        ),
      ),
    );
  }
}
