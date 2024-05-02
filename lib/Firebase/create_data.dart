import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateData {
  Future<void> createCategory(BuildContext context, String newCategory, TextEditingController newCategoryController, Function() onCategoryCreated) async {
    try {
      CollectionReference collRef = FirebaseFirestore.instance.collection("items");
      await collRef.doc(newCategory).set({
        'categoryID': newCategory,
      });

      onCategoryCreated();
      Navigator.of(context).pop();
      newCategoryController.clear();
    } catch (e) {
      // print('Error creating category: $e');
    }
  }

  Future<void> createItem(BuildContext context, String type, String _itemName, String _price, String _description) async {
    try {
      // Reference to the document representing the type
      DocumentReference typeDocRef = FirebaseFirestore.instance.collection("items").doc(type);

      // Add a document under the type document
      await typeDocRef.collection('content').doc(_itemName).set({
        'item_picture': "",
        'item_name': _itemName,
        'price': _price,
        'description': _description,
        'category': type,
      });

      Navigator.of(context).pop();
    } catch (e) {
      // Handle error
      print(e);
    }
  }

}

