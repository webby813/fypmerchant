import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Color/color.dart';
import '../../Components/barTitle_widget.dart';
import '../../Components/listTile_widget.dart';
import '../../login.dart';
import 'ManageTabsTablet/StockManage/StockManageTablet.dart';
import 'ManageTabsTablet/mainAreaManage.dart';

class ManageTablet extends StatefulWidget {
  const ManageTablet({super.key});

  @override
  State<ManageTablet> createState() => _ManageTabletState();
}

class _ManageTabletState extends State<ManageTablet> {
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
                                    typeNum = 1;
                                  });
                                }
                            ),
                            CustomListTile.tile(
                                title: "Manage Stock",
                                onTap: (){
                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ManageStockPage()));
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

            Expanded(
                flex: 12,
                child: Container(
                  child: MainAreaManage(type: typeNum),
                )
            )
          ],
        )
    );
  }
}
