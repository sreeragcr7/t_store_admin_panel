import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:t_store_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store_admin_panel/data/repositories/user/user_repository.dart';
import 'package:t_store_admin_panel/features/authentication/controllers/user_controllers.dart';
import 'package:t_store_admin_panel/features/authentication/models/user_model.dart';
import 'package:t_store_admin_panel/utils/constants/enums.dart';
import 'package:t_store_admin_panel/utils/constants/image_strings.dart';
import 'package:t_store_admin_panel/utils/constants/text_strings.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class LoginControllers extends GetxController {
  static LoginControllers get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();

  final email = TextEditingController();
  final password = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSSWORD') ?? '';
    super.onInit();
  }

  //Handling  email & password sign in process
  Future<void> emailAndPasswordSignIn() async {
    try {
      //Start loading
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.emailLoading);

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Save data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSSWORD', password.text.trim());
      }

      //Login user using email & password
      await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Fetch user details & assign to UserController
      final user = await UserControllers.instance.fetchUserDetails();

      //Remove loader
      TFullScreenLoader.stopLoading();

      //If user is not admin, logout & return
      if (user.role != AppRole.admin) {
        await AuthenticationRepository.instance.logout();
        TLoaders.errorSnackBar(
          title: 'Not Autherizes',
          message: 'You are not authorized or do not have access. Contact Admin',
        );
      } else {
        //Redirect
        AuthenticationRepository.instance.screenRedirect();
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  //Handles registration of admin user
  Future<void> registerAdmin() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('Registering Admin Account...', TImages.emailLoading);

      //Check Internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Register user using Email & Password Authentication
      await AuthenticationRepository.instance.registerWithEmailAndPassword(TTexts.adminEmail, TTexts.adminPassword);

      //Create Admin record in Firestore
      final userRepository = Get.put(UserRepository());
      await userRepository.createUser(
        UserModel(
          id: AuthenticationRepository.instance.authUser!.uid,
          firstName: 'CwT',
          lastName: 'Admin',
          email: TTexts.adminEmail,
          role: AppRole.admin,
          createdAt: DateTime.now(),
        ),
      );

      //Remove loader
      TFullScreenLoader.stopLoading();

      //Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
