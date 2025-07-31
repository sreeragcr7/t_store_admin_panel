import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //App Setting
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(vertical: TSizes.lg, horizontal: TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Setting', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              Form(
                child: Column(
                  children: [
                    // First Name (top field)
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                        label: Text('First Name'),
                        prefixIcon: Icon(Iconsax.user),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Tax, Shipping, and Free Shipping in a row
                    Row(
                      children: [
                        //Tax rate
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Tax %',
                              label: Text('Tax Rate (%)'),
                              prefixIcon: Icon(Iconsax.tag),
                              enabled: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),

                        //Shipping cost
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Shipping Cost',
                              label: Text('Shipping Cost (\$)'),
                              prefixIcon: Icon(Iconsax.ship),
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),

                        //Free shipping Threshold
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Free Shipping After (\$)',
                              label: Text('Free Shipping Threshold (\$)'),
                              prefixIcon: Icon(Iconsax.ship),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Update Button
                    const SizedBox(height: TSizes.spaceBtwInputFields * 2),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () {}, child: const Text('Update Profile')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
