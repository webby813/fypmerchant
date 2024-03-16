import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTabsTablet/mainArea.dart';
import '../../Color/color.dart';
import '../../Components/barTitle_widget.dart';
import '../Mobile/OrderTabsMobile/HistoryOrderMobile.dart';
import '../Mobile/OrderTabsMobile/PendingOrderMobile.dart';
import 'OrderTabsTablet/ReceiveOrderTablet.dart';

class OrderTablet extends StatefulWidget {
  const OrderTablet({Key? key}) : super(key: key);

  @override
  State<OrderTablet> createState() => _OrderTabletState();
}

class _OrderTabletState extends State<OrderTablet> {
  String? selectedUsername;

  void setSelectedUsername(String? username) {
    setState(() {
      selectedUsername = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabViews = [
      ReceiveOrderTablet(onCardTap: setSelectedUsername),
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
            flex: 6, // Adjusted flex value
            child: Container(
              color: CustomColors.indigo,
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

          Expanded(
            flex: 12,
            child: Container(
              child: selectedUsername != null ? MainAreaOrder(selectedUsername: selectedUsername!) : Container()
            ),
          ),
        ],
      ),
    );

  }
}