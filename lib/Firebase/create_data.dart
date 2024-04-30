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

  Future<void> createItem(BuildContext context, String type, String _itemName, String _price, String _description)async{
    try{
      CollectionReference collRef = FirebaseFirestore.instance.collection("items");
      await collRef.doc(type).collection(_itemName).doc(_itemName).set({
        'item_picture' : "",
        'item_name' : _itemName,
        'price' : _price,
        'description' : _description,
        'category' : type
      });

      Navigator.of(context).pop();
    }catch(e){
      // print(e);
    }
  }
}

