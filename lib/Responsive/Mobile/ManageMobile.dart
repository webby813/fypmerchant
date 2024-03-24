import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Mobile/ManageTabsMobile/ShopStatusMobile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Color/color.dart';
import '../../Components/barTitle_widget.dart';
import '../../Components/listTile_widget.dart';
import '../../login.dart';

class ManageMobile extends StatefulWidget {
  const ManageMobile({super.key});

  @override
  State<ManageMobile> createState() => _ManageMobileState();
}

class _ManageMobileState extends State<ManageMobile> {
  late int typeNum = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.defaultWhite,
        title: BarTitle.appBarText('Manage'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              onPressed: ()
              async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear shared preferences
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                      (Route<dynamic> route) => false, // Remove all existing routes from the stack
                );
              },
              color: Colors.blue,
              icon: const Icon(Icons.exit_to_app_rounded)
          )
        ],
      ),
      backgroundColor: CustomColors.defaultWhite,
      body: Row(
        children: [
          Expanded(
              flex: 6,
              child: Container(
                alignment: Alignment.topLeft,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Wrap(
                        runSpacing: 12,
                        children: [
                          //Manage Stock and Shop
                          ListTileTitle.tileTitle(title: "Shop and Stock Manage"),
                          CustomListTile.tile(
                              title: "Shop Status",
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ShopStatusMobile()));
                                });
                              }
                          ),
                          CustomListTile.tile(
                              title: "Manage Stock",
                              onTap: (){
                                setState(() {
                                  typeNum = 2;
                                });
                              }
                          ),

                          ListTileTitle.tileTitle(title: "Need help?"),
                          CustomListTile.tile(
                              title: "Help Centre",
                              onTap: (){
                                setState(() {

                                });
                              }
                          ),
                          CustomListTile.tile(
                              title: "Feedback",
                              onTap: (){
                                setState(() {

                                });
                              }
                          ),

                          ListTileTitle.tileTitle(title: "About me"),
                          CustomListTile.tile(
                              title: "About me",
                              onTap: (){
                                setState(() {

                                });
                              }
                          ),

                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}
