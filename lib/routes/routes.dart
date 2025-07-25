class TRoutes {
  static const firstScreen = '/';
  static const responsiveDesignTutScreen = '/responsive-design-tutorial/';
  static const secondScreen = '/second-screen/';
  static const secondScreenUID = '/second-screen/:userId';

  static const login = '/login';
  static const forgetPassword = '/forget-password/';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const media = '/media';

  static const banners = '/banners';
  static const createBanner = '/createBanner';
  static const editBanner = '/editBanner';

  static const products = '/products';
  static const createProduct = '/createProduct';
  static const editProduct = '/editProduct';

  static const categories = '/categories';
  static const createCategory = '/createCategory';
  static const editCategory = '/editCategory';

  static const brands = '/brands';
  static const createBrand = '/createBrand';
  static const editBrand = '/editBrand';

  static const customers = '/customers';
  static const customerDetails = '/customerDetails';

  static const orders = '/orders';
  static const orderDetails = '/orderDetails';
  static const createOrder = '/createOrder';
  static const editOrder = '/editOrder';

  static List sideBarMenuItems = [dashboard, media, categories, brands];
}
