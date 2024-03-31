import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Color/color.dart';
import '../../Components/listTile_widget.dart';
import '../../Components/textTitle_widget.dart';
import '../../login.dart';
import 'ManageTabsTablet/ManageStock/stock_manage_tablet.dart';
import 'ManageTabsTablet/mainArea_converter.dart';

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
          title: AppBarWidget.bartext('Manage'),
          elevation: 0,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text("Exit"),
                        content: const Text("Exit and store will be closed"),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.clear(); // Clear shared preferences
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const Login()),
                                    (Route<dynamic> route) => false, // Remove all existing routes from the stack
                              );
                            },
                          ),
                        ],
                      );
                    },
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageStockPage()));
                                  });
                                }
                            ),

                            ListTileTitle.tileTitle(title: "Need help?"),
                            CustomListTile.tile(
                                title: "Help Centre",
                                onTap: (){
                                  setState(() {
                                    typeNum = 3;
                                  });
                                }
                            ),
                            CustomListTile.tile(
                                title: "Feedback",
                                onTap: (){
                                  setState(() {
                                    typeNum = 4;
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
                child: MainAreaManage(type: typeNum)
            )
          ],
        )
    );
  }
}
