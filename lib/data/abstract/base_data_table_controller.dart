import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store_admin_panel/utils/constants/size.dart';
import 'package:t_store_admin_panel/utils/popups/full_screen_loader.dart';
import 'package:t_store_admin_panel/utils/popups/loaders.dart';

abstract class TBaseController<T> extends GetxController {
  RxBool isLoading = false.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<T> allItems = <T>[].obs;
  RxList<T> filteredItems = <T>[].obs;
  RxList<bool> selectedRows = <bool>[].obs;
  final searchTextController = TextEditingController();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  //Abstract method to be implemented by subclasses for fetching items.
  Future<List<T>> fetchItems();

  //Abstract method to be implemented by subclasses for deleting an item.
  Future<void> deleteItem(T item);

  //Abstract method to be implemented by subclasses for checking if an item contains the search query.
  bool containsSearchQuery(T item, String query);

  //Fetch data
  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      List<T> fetchedItems = [];
      if (allItems.isEmpty) {
        fetchedItems = await fetchItems();
      }

      allItems.assignAll(fetchedItems); //Assign fetched item to the allItems list
      filteredItems.assignAll(allItems); //Initially, set filtered items to all items
      selectedRows.assignAll(List.generate(allItems.length, (_) => false)); //Initialize selected rows
    } catch (e) {
      isLoading.value = false;
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //Search query
  void searchQuery(String query) {
    filteredItems.assignAll(allItems.where((item) => containsSearchQuery(item, query)));
  }

  //Sort by name
  void sortByProperty(int sortColumnIndex, bool ascending, Function(T) property) {
    sortAscending.value = ascending;
    this.sortColumnIndex.value = sortColumnIndex;
    filteredItems.sort((a, b) {
      if (ascending) {
        return property(a).compareTo(property(b));
      } else {
        return property(b).compareTo(property(a));
      }
    });
  }

  // //Sort by parent name
  // void sortByParentName(int sortColumnIndex, bool ascending, Function(T) property) {
  //   sortAscending.value = ascending;
  //   this.sortColumnIndex.value = sortColumnIndex;

  //   filteredItems.sort((a, b) {
  //     if (ascending) {
  //       return property(a).compareTo(property(b));
  //     } else {
  //       return property(b).compareTo(property(a));
  //     }
  //   });
  // }

  //Method for adding an item to the lists
  void addItemToLists(T item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false));

    filteredItems.refresh(); //Refresh the UI to reflect the changes
  }

  //Method for updating an item from the lists.
  void updateItemFromLists(T item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);

    if (itemIndex != -1) allItems[itemIndex] = item;
    if (filteredItemIndex != -1) filteredItems[itemIndex] = item;

    filteredItems.refresh(); //Refresh UI to reflect the change
  }

  //Method for removing an item from the lists.
  void removeItemFromTheList(T item) {
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false)); //Initialize slected rows

    // update(); //Trigger UI Update
  }

  //confirmation delete
  void confirmAndDeleteItem(T item) {
    //Show a confirmation dialog
    Get.defaultDialog(
      title: 'Delete Item',
      content: const Text('Are you sure you want to delete this item?'),
      confirm: SizedBox(
        width: 60,
        child: ElevatedButton(
          onPressed: () async => await deleteOnConfirm(item),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight / 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5)),
          ),
          child: Text('Delete'),
        ),
      ),
      cancel: SizedBox(
        width: 80,
        child: OutlinedButton(
          onPressed: () => Get.back(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight / 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.buttonRadius * 5)),
          ),
          child: const Text('Cancle'),
        ),
      ),
    );
  }

  //delete
  Future<void> deleteOnConfirm(T item) async {
    try {
      //Remove the confirmation dialogue
      TFullScreenLoader.stopLoading();

      //Start the loader
      TFullScreenLoader.popUpCircular();

      //Delete Firestore Data
      await deleteItem(item); //!

      removeItemFromTheList(item);

      update();

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Item Deleted', message: 'Your Item has been Deleted');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
