import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/spinner_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/alertDialog_widget.dart';
import '../SharedPref/pref.dart';
import '../home.dart';

class RetrieveData {
  Future<List<String>> retrieveCategories() async {
    try {
      CollectionReference collRef = FirebaseFirestore.instance.collection('items');
      QuerySnapshot snapshot = await collRef.get();
      List<String> categories = snapshot.docs.map((doc) => doc.id).toList();

      return categories;
    } catch (e) {
      print('Error retrieving categories: $e');
      return [];
    }
  }

  Future<void> fetchPaidAmount(String orderId, Function(double, String) updateValues) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Orders')
          .where('order_id', isEqualTo: orderId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        double paidAmount = documentSnapshot['paid_Amount'] ?? 0.0;
        String paymentMethod = documentSnapshot['payment_method'] ?? Spinner();
        updateValues(paidAmount, paymentMethod);
      } else {
        print('No order found with order_id: $orderId');
      }
    } catch (error) {
      print('Error fetching paid amount: $error');
    }
  }

  Stream<double> getWalletBalance() async* {
    final dbRef = FirebaseFirestore.instance;
    yield* dbRef
        .collection('merchant')
        .doc('Merchant')
        .snapshots()
        .map((snapshot) => (snapshot['balance'] ?? 0).toDouble());
  }

}

class RetrievePicture {
  Future<String?> loadItemPicture(String item_picture) async {
    final storeRef = FirebaseStorage.instance.ref().child('Items/$item_picture');
    try {
      final imageUrl = await storeRef.getDownloadURL();
      return imageUrl.toString();
    } catch (e) {
      print('Error retrieving image URL: $e');
      return null;
    }
  }
}

class Checking{
  void checkCredential(context, String username, String password)async{
    final db = FirebaseFirestore.instance;

    Future<void> saveLoggedInFlag() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
    }

    try{
      QuerySnapshot snapshot = await db.collection('merchant').where('username', isEqualTo: username).where('password', isEqualTo: password).get();
      if(snapshot.docs.isNotEmpty){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
        setSharedPref(username, password);
        saveLoggedInFlag();
      }
      else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogWidget(
              title: 'Error',
              content: 'Please ensure correct login credential',
            );
          },
        );
      }
    }catch(e){
      // print(e);
    }
  }
}