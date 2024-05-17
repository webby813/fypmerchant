import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTabsTablet/pending_order_tablet.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTabsTablet/mainArea_Order.dart';
import '../../Color/color.dart';
import '../../Components/textTitle_widget.dart';
import 'OrderTabsTablet/history_order.dart';
import 'OrderTabsTablet/receive_order_tablet.dart';

class OrderTablet extends StatefulWidget {
  const OrderTablet({Key? key}) : super(key: key);

  @override
  State<OrderTablet> createState() => _OrderTabletState();
}

class _OrderTabletState extends State<OrderTablet> {
  String? order_Id;
  int selectedIndex = 0;

  void setOrderId(String? newOrderId, int areaType) {
    setState(() {
      order_Id = newOrderId;
      selectedIndex = areaType;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabViews = [
      ReceiveOrderTablet(
        onCardTap: (order_Id) {
          setOrderId(order_Id, 1); // Pass areaType as 1 for MainAreaOrder
        },
      ),
      PendingOrderTablet(
          onCardTap: (order_Id) {
            setOrderId(order_Id, 2); // Pass areaType as 2 for PendingOrder
          }),
      HistoryOrderTablet(
          onCardTap: (order_Id) {
            setOrderId(order_Id, 3); // Pass areaType as 3 for HistoryOrder
          }),
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
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.defaultWhite,
        title: AppBarWidget.bartext('Orders'),
        elevation: 0,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              color: CustomColors.primaryColor,
              child: Scaffold(
                body: SafeArea(
                  child: DefaultTabController(
                    length: tabs.length,
                    initialIndex: selectedIndex,
                    child: Column(
                      children: [
                        TabBar(
                          tabs: tabs,
                          labelColor: CustomColors.primaryColor,
                          onTap: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
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
              child: order_Id != null
                  ? MainArea(
                order_id: order_Id!,
                areaType: 1,
              )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}

