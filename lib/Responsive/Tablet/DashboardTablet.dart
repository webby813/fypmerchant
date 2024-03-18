import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Tablet/DashboardTabsTablet/PayoutTablet.dart';

import '../../Color/color.dart';
import '../../Components/barTitle_widget.dart';
import '../../Components/tabbar_widget.dart';
import '../Mobile/DashboardTabsMobile/InsightsMobile.dart';
import '../Mobile/DashboardTabsMobile/PayoutMobile.dart';

class DashboardTablet extends StatefulWidget {
  const DashboardTablet({super.key});

  @override
  State<DashboardTablet> createState() => _DashboardTabletState();
}

class _DashboardTabletState extends State<DashboardTablet> {

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