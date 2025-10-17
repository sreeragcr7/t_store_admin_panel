import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store_admin_panel/features/personalization/models/address_model.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  //Fetch user addresses from Firestore based on userId
  Future<List<AddressModel>> fetchUserAddresses(String userId) async {
    try {
      //Query Firestore collection to get user addresses
      final result = await _db.collection('Users').doc(userId).collection('Addresses').get();

      //Covert Firestore document snapshot to AddressModel objects
      return result.docs.map((documentSnapshot) => AddressModel.fromDocumentSnapshot(documentSnapshot)).toList();
    } catch (e) {
      //Throw error if fetching address fails
      throw 'Something went wrong while fetching address informtion. Try again later';
    }
  }

  //Update the 'SelectedAddress' field for a specific adress
  Future<void> updateSelectedField(String addressId, bool selected) async {
    try {
      //Get the current users ID
      final userId = AuthenticationRepository.instance.authUser!.uid;
      //Update the selected field for the specified address in Firestore
      await _db.collection('Users').doc(userId).collection('Addresses').doc(addressId).update({
        'SelectedAddress': selected,
      });
    } catch (e) {
      //Throw error if fetching address fails
      throw 'Unable to update your address selection. Try again later';
    }
  }

  //Add a new address to firestore
  Future<String> addAddress(AddressModel address) async {
    try {
      //Get the current user ID
      final userId = AuthenticationRepository.instance.authUser!.uid;
      //Add address to the users collection in Firestore
      final currentAddress = await _db.collection('Users').doc(userId).collection('Addresses').add(address.toJson());
      //Return the ID of the newly added address
      return currentAddress.id;
    } catch (e) {
      //Throw error if fetching address fails
      throw 'Soemthing went wrong while saving address Information. Try again later';
    }
  }

}
