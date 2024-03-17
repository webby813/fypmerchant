import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/alertDialog_widget.dart';
import '../SharedPref/pref.dart';
import '../home.dart';

class Identify{
  final dbRef = FirebaseDatabase.instance.reference().child('Merchant');

  List dataList = [];
  List dataKeyList = [];

  Future<void> login(context, String username, String password) async{
    dbRef.onValue.listen((event) {
      for(final child in event.snapshot.children){
        Map<dynamic,dynamic> obj = child.value as Map<dynamic, dynamic>;
        dataList.add(obj);
        dataKeyList.add(obj);
        for(var i=0; i!= dataList.length;i++){
        }

        try{
          for(var i=0; i!= dataList.length;i++){
            if(username != dataList[i]["Username"] || password != dataList[i]['Password']){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialogWidget(Title: 'Error', content: 'Ensure credential is valid');
                },
              );
            }
            else if(username == dataList[i]['Username'] && password == dataList[i]['Password']){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
              setSharedPref(username, password);
              saveLoggedInFlag();
              dataKeyList.clear();
              dataList.clear();
              break;
            }
            else{
              break;
            }
          }
        }catch(error){
        }
      }
    }
    );
  }

  Future<void> saveLoggedInFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }
}