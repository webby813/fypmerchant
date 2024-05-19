import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Components/alertDialog_widget.dart';

class UpdateData {
  Future<void> updateCategory(BuildContext context, String selectedCategory, String newCategoryId, Function() onCategoryUpdate) async {
    FirebaseFirestore dbRef = FirebaseFirestore.instance;
    final currentDocRef = dbRef.collection('items').doc(selectedCategory);
    final newDocRef = dbRef.collection('items').doc(newCategoryId);

    try {
      final oldData = await currentDocRef.get();
      if (oldData.exists) {
        Map<String, dynamic> newData = oldData.data()!;
        newData['categoryID'] = newCategoryId;
        await newDocRef.set(newData);
        await currentDocRef.delete();
        onCategoryUpdate();

      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateItem(
      BuildContext context,
      String? imagePath,
      String? newPicture,
      String selectedCategory,
      String docID,
      String newItemName,
      String newPrice,
      String newDescription,
      ) async {
    try {
      final storage = FirebaseStorage.instance.ref('Items/$newPicture');
      FirebaseFirestore dbRef = FirebaseFirestore.instance;

      if (imagePath != null) {
        File imageFile = File(imagePath);
        // Upload the new image to Firebase Storage
        await storage.putFile(imageFile);
      }

      // Create a map to hold the updated item data
      Map<String, dynamic> updatedData = {
        'description': newDescription,
        'item_name': newItemName,
        'price': newPrice,
      };

      // If a new picture is selected, add it to the updated data
      if (newPicture != null) {
        updatedData['item_picture'] = newPicture;
      }

      // Update the item with the new data
      await dbRef
          .collection('items')
          .doc(selectedCategory)
          .collection('content')
          .doc(docID)
          .update(updatedData);

      Navigator.pop(context);
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }


  Future<void> updateToNewDocument(
      String currentPicture,
      String selectedCategory,
      String oldDocID,
      String newDocID) async {
    try {
      FirebaseFirestore dbRef = FirebaseFirestore.instance;

      DocumentSnapshot oldDocSnapshot = await dbRef.collection('items')
          .doc(selectedCategory)
          .collection('content')
          .doc(oldDocID)
          .get();
      Map<String, dynamic> oldData = oldDocSnapshot.data() as Map<String, dynamic>;

      await dbRef.collection('items')
          .doc(selectedCategory)
          .collection('content')
          .doc(newDocID)
          .set(oldData);

      await dbRef.collection('items')
          .doc(selectedCategory)
          .collection('content')
          .doc(oldDocID)
          .delete();
    } catch (e) {
      // Handle error
    }
  }
}


class ManageOrder{
  Future<void> acceptOrder(context, order_id, grandTotal) async {
    final dbRef = FirebaseFirestore.instance;
    double currentBlc = 0.0;

    QuerySnapshot orderQuery = await dbRef
        .collection('Orders')
        .where('order_id', isEqualTo: order_id)
        .get();

    QuerySnapshot merchantBlcQuery = await dbRef
        .collection('merchant')
        .get();

    if (orderQuery.docs.isNotEmpty && merchantBlcQuery.docs.isNotEmpty) {
      DocumentSnapshot orderSnapshot = orderQuery.docs.first;
      DocumentSnapshot balanceSnapshot = merchantBlcQuery.docs.first;
      currentBlc = balanceSnapshot['balance'];
      currentBlc += grandTotal;

      await dbRef.collection('Orders')
          .doc(orderSnapshot.id)
          .update({'order_Status': 'Preparing'});

      await dbRef.collection('merchant')
          .doc(balanceSnapshot.id)
          .update({'balance': currentBlc});
    } else {
      print('No order found with order_id: ${order_id}');
    }
  }

  Future<void> rejectOrder(context, order_id) async {

    try{
      final dbRef = FirebaseFirestore.instance;
      bool paid_Status;
      String user_Email = "";
      double paid_Amount = 0.0;
      double currentBlc = 0.0;

      QuerySnapshot orderQuery = await dbRef.collection('Orders').where('order_id', isEqualTo: order_id).get();

      if(orderQuery.docs.isNotEmpty){
        DocumentSnapshot orderSnapshot = orderQuery.docs.first;
        paid_Status = orderSnapshot['paid'];
        user_Email = orderSnapshot['user_email'];
        paid_Amount = orderSnapshot['paid_Amount'];

        QuerySnapshot userPath = await dbRef.collection('users').where('email', isEqualTo: user_Email).get();
        if (userPath.docs.isNotEmpty && paid_Status == true) {
          DocumentSnapshot userDocument = userPath.docs.first;
          currentBlc = userDocument['wallet_balance'];
          currentBlc += paid_Amount;

          await dbRef.collection('users')
              .doc(userDocument.id)
              .update({'wallet_balance': currentBlc});

          await dbRef.collection('Orders')
              .doc(orderSnapshot.id)
              .update({'order_Status': 'Canceled'});

        } else if(paid_Status == false){
          await dbRef.collection('Orders')
              .doc(orderSnapshot.id)
              .update({'order_Status': 'Canceled'});

        } else {
          print("error");
        }
      } else {
        print('error');
      }

    }catch(e){
      print(e);
    }
  }

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String currentTimeKey = DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> readCartData(String username) async {
    _databaseReference.child("Order").child(username).get().then((DataSnapshot snapshot) {
      // Check if the snapshot contains data
      if (snapshot.value != null) {
        // Convert the dynamic value to Map<dynamic, dynamic>
        Map<dynamic, dynamic>? cartData = snapshot.value as Map<dynamic, dynamic>?;
        if (cartData != null) {
          createNewDataset(cartData, username);
        } else {
          // print("Invalid data format for Cart data.");
        }
      } else {
        // print("Cart data is empty.");
      }
    }).catchError((error) {
      // print("Error reading cart data: $error");
    });
  }

  void createNewDataset(Map<dynamic, dynamic> cartData, username) async {
    try {
      // Here, you can create a new dataset in the Firebase Realtime Database
      // For example, if you want to store it under a new node named "NewCart":
      await _databaseReference.child("Pending/$username").set(cartData);
      // print("New dataset created successfully");
      remove(username);
    } catch (error) {
      // print("Error creating new dataset: $error");
    }
  }

  void remove(username) async{
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Order/$username');
    ref.remove();
  }
}






class RejectOrder{
  Future<void> rejectUserOrder(username) async{
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Order/$username');
    ref.remove();
  }
}

class PendingFinish{
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String currentTimeKey = DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> readCartData(String username) async {
    _databaseReference.child("Pending").child(username).get().then((DataSnapshot snapshot) {
      // Check if the snapshot contains data
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? cartData = snapshot.value as Map<dynamic, dynamic>?;
        if (cartData != null) {
          createNewDataset(cartData, username);
        } else {
          // print("Invalid data format for Cart data.");
        }
      } else {
        // print("Cart data is empty.");
      }
    }).catchError((error) {
      // print("Error reading cart data: $error");
    });
  }

  void createNewDataset(Map<dynamic, dynamic> cartData, username) async {
    String currentTimeKey = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await _databaseReference.child("History/$username$currentTimeKey").set(cartData);
      remove(username);
    } catch (error) {
    }
  }

  void remove(username) async{
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Pending/$username');
    ref.remove();
  }
}

