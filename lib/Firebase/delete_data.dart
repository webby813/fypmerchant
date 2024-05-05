import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteData {
  Future<void> deleteCategory(BuildContext context, String selectedCategory, Function() onCategoryDelete) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final dbRef = db.collection('items').doc(selectedCategory);
      await dbRef.delete();

      onCategoryDelete();

    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteItem(String selectedCategory, String docID)async{
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final dbRef = db.collection('items').doc(selectedCategory).collection('content').doc(docID).delete();

    }catch(e){
      print(e);
    }
  }

}

