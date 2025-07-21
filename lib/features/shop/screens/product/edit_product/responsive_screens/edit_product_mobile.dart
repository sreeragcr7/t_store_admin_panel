import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:t_store_admin_panel/common/widgets/breadcrumbs/breadcrumbs_with_heading.dart';
import 'package:t_store_admin_panel/common/widgets/custom_shapes/containers/t_rounded_container.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/additional_images.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/attributes_widget.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/bottom_navigation_widget.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/brand_widget.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/categories_widget.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/product_type_widget.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/stock_pricing_widget.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/thumbnail_widget.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/title_description.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/variations_widget.dart';
import 'package:t_store_admin_panel/features/shop/screens/product/create_product/widgets/visibility_widget.dart';
import 'package:t_store_admin_panel/utils/device/device_utility.dart';

class EditProductMobileScreen extends StatelessWidget {
  const EditProductMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const ProductBottomNavigationButtons(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Breadscrumbs
              TBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Create Product',
                breadscrumbItems: [TRoutes.products, 'Create Product'],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              //Create Product
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: TDeviceUtils.isTabletScreen(context) ? 2 : 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Basic Information
                        const ProductTitleAndDescription(),

                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Stock & Pricing
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Heading
                              Text('Stock & Pricing', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),

                              //Product Type
                              const ProductTypeWidget(),
                              const SizedBox(height: TSizes.spaceBtwInputFields),

                              //Stock
                              const ProductStockAndPricing(),
                              const SizedBox(height: TSizes.spaceBtwSections),

                              //Attributes
                              const ProductAttributes(), //!image fix
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Variations
                        const ProductVariations(), //!img
                      ],
                    ),
                  ),
                  const SizedBox(width: TSizes.defaultSpace),

                  //Sidebar
                  Expanded(
                    child: Column(
                      children: [
                        //Product Thumbnail
                        const ProductThumbnailImage(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Product Images
                        TRoundedContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('All Product Images', style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              ProductAdditionalImages(
                                additionalProductImagesURLs: RxList<String>.empty(),
                                onTapToAddImages: () {},
                                // onTapToRemoveImage: (index) {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Product Brand
                        const ProductBrand(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Product Categories
                        const ProductCategories(),
                        const SizedBox(height: TSizes.spaceBtwSections),

                        //Product Visiblity
                        const ProductVisibilityWidget(),
                        const SizedBox(height: TSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}