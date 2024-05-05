import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/alertDialog_widget.dart';
import '../Components/spinner_widget.dart';
import '../Responsive/Tablet/ManageTabsTablet/ManageStock/stock_manage_tablet.dart';
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

  static Future<Widget> retrieveItems(String category) async {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('items')
          .doc(category)
          .collection('content')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Spinner.loadingSpinner();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<Widget> itemWidgets = [];
          final items = snapshot.data?.docs.reversed.toList();
          if (items != null) {
            for (var item in items) {
              itemWidgets.add(
                StockItemCardOnTablet(
                  item_name: item['item_name'],
                  price: item['price'], // Example price, replace with actual value
                  description: item['description'],
                  selectedCategory: category,
                ),
              );
            }
          }
          return Column(
            children: itemWidgets,
          );
        }
      },
    );
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