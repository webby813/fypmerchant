import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTabsTablet/ReceiveOrderTablet.dart';
import '../../Color/color.dart';
import '../../Components/barTitle_widget.dart';
import '../Mobile/OrderTabsMobile/HistoryOrderMobile.dart';
import '../Mobile/OrderTabsMobile/PendingOrderMobile.dart';
import '../Mobile/OrderTabsMobile/ReceiveOrderMobile.dart';

class OrderTablet extends StatefulWidget {
  const OrderTablet({Key? key}) : super(key: key);

  @override
  State<OrderTablet> createState() => _OrderTabletState();
}

class _OrderTabletState extends State<OrderTablet> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> tabViews = [
      const ReceiveOrderTablet(),
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
        centerTitle: true,
        backgroundColor: CustomColors.defaultWhite,
        title: BarTitle.appBarText('Orders'),
        elevation: 0,
      ),
      body: Row(
        children: [
          Expanded(
            child: FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: 0.6,
              child: Container(
                color: Colors.blue, // Background color of the column
                child: Scaffold(
                  body: SafeArea(
                    child: DefaultTabController(
                      length: tabs.length,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: tabs,
                            labelColor: CustomColors.primaryColor,
                          ),
                          Expanded(
                            child: TabBarView(
                              children: tabViews,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          //Orders shown in this Expanded
          Expanded(
              child: FractionallySizedBox(
                widthFactor: 1.8,
                child: Container(
                  color: CustomColors.lightGrey,
                ),
              )
          )
        ],
      ),
    );
  }
}
