import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/ManageTab/support_pages.dart';
import 'package:fypmerchant/Responsive/Mobile/ManageTabsMobile/hisotry_page_mobile.dart';
import 'package:fypmerchant/Responsive/Mobile/ManageTabsMobile/stock_manage_mobile.dart';
import 'package:fypmerchant/Responsive/Mobile/ManageTabsMobile/shop_status_mobile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Color/color.dart';
import '../../Components/listTile_widget.dart';
import '../../Components/textTitle_widget.dart';
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
        title: AppBarWidget.bartext('Manage'),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ShopStatusMobile()));
                                });
                              }
                          ),

                          CustomListTile.tile(
                              title: "History",
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPageMobile()));
                                });
                              }
                          ),

                          CustomListTile.tile(
                              title: "Manage Stock",
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageStockMobile()));
                                });
                              }
                          ),

                          ListTileTitle.tileTitle(title: "Need help?"),
                          CustomListTile.tile(
                              title: "Help Centre",
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCentre()));
                                });
                              }
                          ),
                          CustomListTile.tile(
                              title: "Feedback",
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackPage()));
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
