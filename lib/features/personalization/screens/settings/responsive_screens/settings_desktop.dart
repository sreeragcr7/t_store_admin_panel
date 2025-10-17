import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/features/personalization/screens/settings/widgets/settings_form.dart';
import 'package:t_store_admin_panel/features/personalization/screens/settings/widgets/image_meta.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class SettingsDesktopScreen extends StatelessWidget {
  const SettingsDesktopScreen({super.key});

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
              TBreadcrumbsWithHeading(heading: 'Settings', breadscrumbItems: ['Settings']),
              SizedBox(height: TSizes.spaceBtwSections),

              //Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Profile Pic and Meta
                  Expanded(child: ImageAndMeta()),
                  SizedBox(width: TSizes.spaceBtwSections),

                  //Form
                  Expanded(flex: 2, child: SettingsForm()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
