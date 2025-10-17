import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/features/personalization/models/settings_model.dart';
import 'package:t_store_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:t_store_admin_panel/utils/exceptions/platform_exceptions.dart';

class SettingsRepository extends GetxController {
  static SettingsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Funtion to save settings data to Firestore.
  Future<void> registerSettings(SettingsModel setting) async {
    try {
      await _db.collection('Settings').doc('GLOBAL_SETTINGS').set(setting.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Function to fetch setting details basede on setting ID
  Future<SettingsModel> getSettings() async {
    try {
      final querySnapshot = await _db.collection('Settings').doc('GLOBAL_SETTINGS').get();
      return SettingsModel.fromSnapshot(querySnapshot);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Function to update settings data in Firestore
  Future<void> updateSettingDetails(SettingsModel updatedSetting) async {
    try {
      await _db.collection('Settings').doc('GLOBAL_SETTINGS').update(updatedSetting.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Update any field in specific Settings Collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection('Settings').doc('GLOBAL_SETTINGS').update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
