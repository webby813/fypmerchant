import 'package:flutter/material.dart';
import '../../../Color/color.dart';
import '../../../Components/barTitle_widget.dart';
import '../../Mobile/OrderTabsMobile/HistoryOrderMobile.dart';
import '../../Mobile/OrderTabsMobile/PendingOrderMobile.dart';
import '../../Mobile/OrderTabsMobile/ReceiveOrderMobile.dart';

class ReceiveOrderTablet extends StatefulWidget {
  const ReceiveOrderTablet({Key? key}) : super(key: key);

  @override
  State<ReceiveOrderTablet> createState() => _ReceiveOrderTabletState();
}

class _ReceiveOrderTabletState extends State<ReceiveOrderTablet> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> tabViews = [
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
        title: BarTitle.appBarText('Check Orders'),
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
