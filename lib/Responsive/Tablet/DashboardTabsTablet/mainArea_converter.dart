import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Tablet/DashboardTabsTablet/insights_tablet.dart';
import 'package:fypmerchant/Responsive/Tablet/DashboardTabsTablet/payout_tablet.dart';

class MainAreaDashboard extends StatelessWidget {
  final int type;
  const MainAreaDashboard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: areaWidget(),
    );
  }
  Widget areaWidget(){
    switch (type){
      case 1:
        return const InsightsTablet();
      case 2:
        return const PayoutTablet();
      default:
        return const InsightsTablet();
    }
  }
}

