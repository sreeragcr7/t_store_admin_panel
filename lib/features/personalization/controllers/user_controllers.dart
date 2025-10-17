import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/data/repositories/user/user_repository.dart';
import 'package:t_store_admin_panel/features/media/controllers/media_controller.dart';
import 'package:t_store_admin_panel/features/media/models/image_model.dart';
import 'package:t_store_admin_panel/features/personalization/models/user_model.dart';
import 'package:t_store_admin_panel/utils/helpers/network_manager.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

class UserControllers extends GetxController {
  static UserControllers get instance => Get.find();

  //Observable variables
  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  //Dependencies
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    //Fetch user details on controller initialization
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
      TLoaders.errorSnackBar(title: 'Something went wrong!.', message: e.toString());
      return UserModel.empty();
    }
  }

  //Pick thumbnail image from media
  void updateProfilePicture() async {
    try {
      loading.value = true;
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

      //Handle the selected images
      if (selectedImages != null && selectedImages.isNotEmpty) {
        //Set the selected image to the main image or perform any other action.
        ImageModel selectedImage = selectedImages.first;

        //Update Profile in Firestore
        await userRepository.updateSingleField({'ProfilePicture': selectedImage.url});

        //Update the main image using the selectedImage
        user.value.profilePicture = selectedImage.url;
        user.refresh();
        TLoaders.successSnackBar(title: 'Congratulations', message: 'Your profile picture has been updated');
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  void updateUserInformation() async {
    try {
      loading.value = true;

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      user.value.firstName = firstNameController.text.trim();
      user.value.lastName = lastNameController.text.trim();
      user.value.phoneNumber = phoneController.text.trim();

      await userRepository.updateUserDetails(user.value);
      user.refresh();

      loading.value = false;
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your profile has been updated');
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
