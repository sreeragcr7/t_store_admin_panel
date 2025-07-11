import 'package:get/get.dart';
import 'package:t_store_admin_panel/data/repositories/user/user_repository.dart';
import 'package:t_store_admin_panel/features/authentication/models/user_model.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class UserControllers extends GetxController {
  static UserControllers get instance => Get.find();

  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    fetchUserDetails();
    super.onInit();
  }

  //Fetches user details from repository
  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      final user = await userRepository.fetchAdminDetails();
      this.user.value = user;
      loading.value = false;   
      return user;
    } catch (e) {
      loading.value = false;   
      TLoaders.errorSnackBar(title: 'Something went wrong!.', message: e.toString());
      return UserModel.empty();
    }
  }
}
