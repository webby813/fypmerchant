import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/tabbar_widget.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Responsive/Mobile/OrderTabsMobile/history_order_mobile.dart';
import 'package:fypmerchant/Responsive/Mobile/OrderTabsMobile/pending_order_mobile.dart';
import 'package:fypmerchant/Responsive/Mobile/OrderTabsMobile/receive_order_mobile.dart';

import '../../Components/textTitle_widget.dart';

class OrderMobile extends StatefulWidget {
  const OrderMobile({super.key});

  @override
  State<OrderMobile> createState() => _OrderMobileState();
}

class _OrderMobileState extends State<OrderMobile> {
  @override
  Widget build(BuildContext context) {

    final List<Widget> tabViews =[
      const ReceiveOrderMobile(),
      const PendingOrderMobile(),
      const HistoryOrderMobile(),
    ];

    final List<Tab> tabs = [
      const Tab(
        text: 'Order',
      ),

      const Tab(
        text: 'Pending',
      ),

      const Tab(
        text: 'History',
      )
    ];

    return Scaffold(
      appBar: AppBar(

        backgroundColor: CustomColors.defaultWhite,
        title: AppBarWidget.bartext('Check Orders'),
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
