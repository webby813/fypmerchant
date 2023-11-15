
import 'package:fypmerchant/Components/button_widget.dart';
import 'package:fypmerchant/Components/container_widget.dart';
import 'package:fypmerchant/Components/divider_widget.dart';
import 'package:fypmerchant/Pages/history.dart';
import 'package:fypmerchant/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: ListView(
        children: [

          DrawerWidget(
              title: "History",
              icon: Icons.history,
              onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const History()));
              }
          ),

          const DivideWidget(),///Divide Line
          DrawerWidget(
              title: "About author",
              icon: Icons.person,
              onPress: (){
              }
          ),

          const DivideWidget(),///Divide Line
          const Padding(padding: EdgeInsets.all(55)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
            child: SecondButtonWidget.buttonWidget('Log out', ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Clear shared preferences
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
                    (
                    Route<dynamic> route) => false, // Remove all existing routes from the stack
              );
            }),
          ),


        ],
      ),
    );
  }
}
