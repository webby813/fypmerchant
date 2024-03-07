import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Color/color.dart';
import '../../Components/barTitle_widget.dart';
import '../../login.dart';

class ManageTablet extends StatefulWidget {
  const ManageTablet({super.key});

  @override
  State<ManageTablet> createState() => _ManageTabletState();
}

class _ManageTabletState extends State<ManageTablet> {
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
                child: FractionallySizedBox(
                  alignment: Alignment.topLeft,
                  widthFactor: 0.6,
                  child: Container(
                    color: Colors.white,
                  ),
                )
            ),

            Expanded(
                child: FractionallySizedBox(
                  widthFactor: 1.8,
                  child: Container(
                    color: CustomColors.lightGrey,
                  ),
                )
            )
          ],
        )
    );
  }
}
