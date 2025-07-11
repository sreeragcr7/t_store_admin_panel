import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/routes/routes.dart';
import 'package:t_store_admin_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:t_store_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:t_store_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:t_store_admin_panel/utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Firebase Auth Instance
  final _auth = FirebaseAuth.instance;

  //Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  //Get isAuthenticated User
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  void onReady() {
    //Redirect to appropriate screen
    _auth.setPersistence(Persistence.LOCAL);
  }

  //Function to determine the relevant screen & redirect accordingly
  void screenRedirect() async {
    final user = _auth.currentUser;

    //If the user is logged in
    if (user != null) {
      //Navigate to the Home
      Get.offAllNamed(TRoutes.dashboard);
    } else {
      Get.offAllNamed(TRoutes.login);
    }
  }

  //Login
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw ('Something went wrong, Please try again!');
    }
  }

  //Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw ('Something went wrong, Please try again!');
    }
  }

  //Register User by Admin

  //Email Verification

  //Forget Password

  //Re-Authenticate User

  //Logout User
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(TRoutes.login);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again!';
    }
  }

  //Delete User
}
