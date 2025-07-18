import 'package:get/get.dart';
import 'package:t_store_admin_panel/features/authentication/screens/forget_password/forget_password.dart';
import 'package:t_store_admin_panel/features/authentication/screens/login/login.dart';
import 'package:t_store_admin_panel/features/authentication/screens/reset_password/reset_password.dart';
import 'package:t_store_admin_panel/features/media/screens/media.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/all_brand/brands.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/create_brand/create_brand.dart';
import 'package:t_store_admin_panel/features/shop/screens/brand/edit_brand/edit_brand.dart';
import 'package:t_store_admin_panel/features/shop/screens/category/all_categories/categories.dart';
import 'package:t_store_admin_panel/features/shop/screens/category/create_category/create_category.dart';
import 'package:t_store_admin_panel/features/shop/screens/category/edit_category/edit_category.dart';
import 'package:t_store_admin_panel/features/shop/screens/dashboard/dashboard.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/routes/routes_middleware.dart';

class TAppRoutes {
  static final List<GetPage> pages = [
    // GetPage(
    //   name: TRoutes.responsiveDesignTutScreen,
    //   page: () => const ResponsiveDesignScreen(),
    //   middlewares: [TRouteMiddleware()],
    // ),
    GetPage(name: TRoutes.login, page: () => const LoginScreen()),
    GetPage(name: TRoutes.forgetPassword, page: () => const ForgetPasswordScreen()),
    GetPage(name: TRoutes.resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(name: TRoutes.dashboard, page: () => const DashboardScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.media, page: () => const MediaScreen(), middlewares: [TRouteMiddleware()]),

    // //Banners
    // GetPage(name: TRoutes.banners, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),
    // GetPage(name: TRoutes.createBanner, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),
    // GetPage(name: TRoutes.editBanner, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),

    // //Products
    // GetPage(name: TRoutes.products, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),
    // GetPage(name: TRoutes.createProduct, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),
    // GetPage(name: TRoutes.editProduct, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),

    //Categories
    GetPage(name: TRoutes.categories, page: () => const CategoriesScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createCategory, page: () => const CreateCategoryScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editCategory, page: () => const EditCategoryScreen(), middlewares: [TRouteMiddleware()]),

    //Brands
    GetPage(name: TRoutes.brands, page: () => const BrandsScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.createBrand, page: () => const CreateBrandScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.editBrand, page: () => const EditBrandScreen(), middlewares: [TRouteMiddleware()]),

    // //Customers
    // GetPage(name: TRoutes.customers, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),
    // GetPage(name: TRoutes.createCustomer, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),
    // GetPage(name: TRoutes.editCustomer, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),

    // //Orders
    // GetPage(name: TRoutes.orders, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),
    // GetPage(name: TRoutes.createOrder, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),
    // GetPage(name: TRoutes.editOrder, page: () => const LoginScreen(), middlewares: [TRouteMiddleware()),
  ];
}
