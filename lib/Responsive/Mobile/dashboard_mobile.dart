import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Mobile/DashboardTabsMobile/insights_mobile.dart';
import 'package:fypmerchant/Responsive/Mobile/DashboardTabsMobile/payout_mobile.dart';
import '../../Color/color.dart';
import '../../Components/tabbar_widget.dart';
import '../../Components/textTitle_widget.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _InsightsMobileState();
}

class _InsightsMobileState extends State<DashboardMobile> {
  final List<Widget> tabViews =[
    const InsightsMobile(),
    const PayoutMobile(),
  ];

  final List<Tab> tabs = [
    const Tab(
      text: 'Insights',
    ),

    const Tab(
      text: 'Payout',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.defaultWhite,
        title: AppBarWidget.bartext('Dashboard'),
        elevation: 0,
      ),

      body: SafeArea(
        child: DefaultTabController(
          length:tabs.length,
          child: Column(
            children: [
              TabBar(
                tabs: tabs,
                labelColor: CustomColors.primaryColor,
              ),

              Expanded(
                child: TabBarWidget(
                    tabs:tabs,
                    tabViews: tabViews
                ).buildTabBarView(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
