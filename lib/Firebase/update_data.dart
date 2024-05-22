import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/alertDialog_widget.dart';
import 'package:fypmerchant/Components/numpad.dart';
import 'package:intl/intl.dart';

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
        await storage.putFile(imageFile);
      }

      Map<String, dynamic> updatedData = {
        'description': newDescription,
        'item_name': newItemName,
        'price': newPrice,
      };

      if (newPicture != null) {
        updatedData['item_picture'] = newPicture;
      }

      await dbRef
          .collection('items')
          .doc(selectedCategory)
          .collection('content')
          .doc(docID)
          .update(updatedData);

      Navigator.pop(context);
    } catch (e) {
      // Handle error
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

  Future<void> withdrawBalance(BuildContext context) async {
    final dbRef = FirebaseFirestore.instance;
    String? input = await showDialog<String>(
      context: context,
      builder: (context) => const NumericKeypadDialog(),
    );

    if (input != null && input.isNotEmpty) {
      double withdrawAmount = double.parse(input);

      DocumentReference merchantDocRef = dbRef.collection('merchant').doc('Merchant');
      DocumentSnapshot merchantDoc = await merchantDocRef.get();
      double currentBalance = merchantDoc['balance'];

      if (withdrawAmount > currentBalance) {
        // Show error dialog if balance is insufficient
        showDialog(
          context: context,
          builder: (context) => const AlertDialogWidget(
            title: 'Insufficient Balance',
            content: 'You do not have enough balance to make this withdrawal.',
          ),
        );
      } else {
        // Proceed with withdrawal
        double newBalance = currentBalance - withdrawAmount;
        DateTime now = DateTime.now();
        Timestamp timestamp = Timestamp.fromDate(now);

        await merchantDocRef.update({'balance': newBalance});
        await dbRef.collection('merchant').doc('Merchant').collection('withdrawals').add({
          'withdraw_Amount': withdrawAmount,
          'withdraw_time': timestamp,
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialogWidget(
            title: 'Transaction Successful',
            content: 'You have successfully completed a withdrawal of RM $withdrawAmount.',
          ),
        );
      }
    }
  }
}


class ManageOrder {
  final dbRef = FirebaseFirestore.instance;

  Future<void> acceptOrder(context, orderId, grandTotal) async {
    double currentBlc = 0.0;

    QuerySnapshot orderQuery = await dbRef
        .collection('Orders')
        .where('order_id', isEqualTo: orderId)
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
      print('No order found with order_id: ${orderId}');
    }
  }

  Future<void> rejectOrder(context, orderId) async {
    try {
      bool paidStatus;
      String userEmail = "";
      double paidAmount = 0.0;
      double currentBlc = 0.0;

      QuerySnapshot orderQuery = await dbRef.collection('Orders').where(
          'order_id', isEqualTo: orderId).get();

      if (orderQuery.docs.isNotEmpty) {
        DocumentSnapshot orderSnapshot = orderQuery.docs.first;
        paidStatus = orderSnapshot['paid'];
        userEmail = orderSnapshot['user_email'];
        paidAmount = orderSnapshot['paidAmount'];

        QuerySnapshot userPath = await dbRef.collection('users').where(
            'email', isEqualTo: userEmail).get();
        if (userPath.docs.isNotEmpty && paidStatus == true) {
          DocumentSnapshot userDocument = userPath.docs.first;
          currentBlc = userDocument['wallet_balance'];
          currentBlc += paidAmount;

          await dbRef.collection('users')
              .doc(userDocument.id)
              .update({'wallet_balance': currentBlc});

          await dbRef.collection('Orders')
              .doc(orderSnapshot.id)
              .update({'order_Status': 'Canceled'});
        } else if (paidStatus == false) {
          await dbRef.collection('Orders')
              .doc(orderSnapshot.id)
              .update({'order_Status': 'Canceled'});
        } else {
          // print("error");
        }
      } else {
        // print('error');
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> readyForPickup(context, orderId) async {
    QuerySnapshot orderQuery = await dbRef.collection('Orders').where(
        'order_id', isEqualTo: orderId).get();
    bool paidStatus;
    double paidAmount;

    if (orderQuery.docs.isNotEmpty) {
      DocumentSnapshot orderSnapshot = orderQuery.docs.first;
      paidStatus = orderSnapshot['paid'];

      await dbRef.collection('Orders')
          .doc(orderSnapshot.id)
          .update({'order_Status': 'Ready for pickup', 'paid': true});
    }
  }

  Future<void> finishOrder(context, orderId) async {
    QuerySnapshot orderQuery = await dbRef.collection('Orders').where(
        'order_id', isEqualTo: orderId).get();

    if (orderQuery.docs.isNotEmpty) {
      DocumentSnapshot orderSnapshot = orderQuery.docs.first;

      await dbRef.collection('Orders')
          .doc(orderSnapshot.id)
          .update({'order_Status': 'Finished'});
    }
  }
}