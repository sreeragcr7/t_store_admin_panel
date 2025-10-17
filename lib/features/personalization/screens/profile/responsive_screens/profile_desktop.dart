import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/personalization/screens/profile/widgets/profile_form.dart';
import 'package:t_store_admin_panel/features/personalization/screens/profile/widgets/image_meta.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProfileDesktopScreen extends StatelessWidget {
  const ProfileDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Breadscrumb
              TBreadcrumbsWithHeading(returnToPreviousScreen: false, heading: 'Profile', breadscrumbItems: ['Profile']),
              SizedBox(height: TSizes.spaceBtwSections / 2),

              //Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Profile Pic and Meta
                  Expanded(child: ImageAndMeta()),
                  SizedBox(width: TSizes.spaceBtwSections),

                  //Form
                  Expanded(flex: 2, child: ProfileForm()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
