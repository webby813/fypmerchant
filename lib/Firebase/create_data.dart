import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateData {
  Future<void> createCategory(context, String newCategory, TextEditingController newCategoryController) async {
    try {
      CollectionReference collRef = FirebaseFirestore.instance.collection("items");
      await collRef.doc(newCategory).set(Map<String, dynamic>());

      Navigator.of(context).pop();
      newCategoryController.clear();
    } catch (e) {
      // print(e);
    }
  }
}