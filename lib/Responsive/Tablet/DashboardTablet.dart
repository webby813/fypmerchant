import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/listTile_widget.dart';
import 'package:fypmerchant/Responsive/Tablet/DashboardTabsTablet/mainAreaDash.dart';
import '../../Color/color.dart';
import '../../Components/barTitle_widget.dart';

class DashboardTablet extends StatefulWidget {
  const DashboardTablet({super.key});

  @override
  State<DashboardTablet> createState() => _DashboardTabletState();
}

class _DashboardTabletState extends State<DashboardTablet> {
  late int typeNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: CustomColors.defaultWhite,
          title: BarTitle.appBarText('Dashboard'),
          elevation: 0,
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
                          runSpacing: 16,
                          children: [
                            CustomListTile.tile(
                                title: "Insights",
                                onTap: (){
                                  setState(() {
                                    typeNum = 1;
                                  });
                              }
                            ),

                            CustomListTile.tile(
                                title: "Payout",
                                onTap: (){
                                  setState(() {
                                    typeNum = 2;
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
                  child: MainAreaDashboard(type: typeNum),
                )
            )
          ],
        )
    );
  }
}