import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/personalization/screens/profile/widgets/form.dart';
import 'package:t_store_admin_panel/features/personalization/screens/profile/widgets/image_meta.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProfileTabletScreen extends StatelessWidget {
  const ProfileTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Breadscrumb
              TBreadcrumbsWithHeading(returnToPreviousScreen: false, heading: 'Profile', breadscrumbItems: ['Profile']),
              SizedBox(height: TSizes.spaceBtwSections / 2),

              //Body
              Column(
                children: [
                  //Profile Pic and Meta
                  ImageAndMeta(),
                  SizedBox(height: TSizes.spaceBtwSections),

                  //Form
                  ProfileForm(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
