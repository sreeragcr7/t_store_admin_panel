import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/page_heading/page_heading.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class TBreadcrumbsWithHeading extends StatelessWidget {
  const TBreadcrumbsWithHeading({
    super.key,
    required this.heading,
    this.returnToPreviousScreen = false,
    required this.breadscrumbItems,
  });

  //Heading of the page
  final String heading;

  //List of bredcrumb items representing the navigation path
  final List<String> breadscrumbItems;

  //Flag indicating weather to include a button to return to the previous screen
  final bool returnToPreviousScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Breadcrumbs Trail
        Row(
          children: [
            //Dashboard link
            InkWell(
              onTap: () => Get.offAllNamed(TRoutes.dashboard),
              child: Padding(
                padding: const EdgeInsets.all(TSizes.xs),
                child: Text('Dashboard', style: Theme.of(context).textTheme.headlineSmall!.apply(fontWeightDelta: -1)),
              ),
            ),

            for (int i = 0; i < breadscrumbItems.length; i++)
              Row(
                children: [
                  const Text('/'), //Seperator

                  InkWell(
                    //Last tem should not be clickable
                    onTap: i == breadscrumbItems.length - 1 ? null : () => Get.toNamed(breadscrumbItems[i]),
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.xs),

                      //Formate breadcrumb item: capitalize & remove leading '/'
                      child: Text(
                        i == breadscrumbItems.length - 1
                            ? breadscrumbItems[i].capitalize.toString()
                            : capitalize(breadscrumbItems[i].substring(1)),
                        style: Theme.of(context).textTheme.headlineSmall!.apply(fontWeightDelta: -1),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: TSizes.sm),

        //Heading of the page
        Row(
          children: [
            if (returnToPreviousScreen) IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left)),
            if (returnToPreviousScreen) const SizedBox(width: TSizes.spaceBtwItems),
            TPageHeading(heading: heading),
          ],
        ),
      ],
    );
  }

  //Function to capitalize
  String capitalize(String s) {
    return s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
  }
}
