import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateData {
  Future<void> createCategory(BuildContext context, String newCategory, TextEditingController newCategoryController) async {
    try {
      CollectionReference collRef = FirebaseFirestore.instance.collection("items");
      await collRef.doc(newCategory).set({
        'categoryID': newCategory,
      });

      Navigator.of(context).pop();
      newCategoryController.clear();
    } catch (e) {
      // Handle error gracefully, maybe show a snackbar or dialog
      print('Error creating category: $e');
    }
  }
}
