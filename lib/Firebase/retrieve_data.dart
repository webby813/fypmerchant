import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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