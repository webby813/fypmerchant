import 'package:flutter/material.dart';
import 'package:fypmerchant/Firebase/pending_order.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTabsTablet/receive_order_tablet.dart';
import '../../../Firebase/history_order.dart';
import '../../../Firebase/view_order.dart';

class MainArea extends StatelessWidget {
  final String order_id;
  final int areaType;

  const MainArea({
    Key? key,
    required this.order_id,
    required this.areaType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: areaWidget(),
    );
  }

  Widget areaWidget() {

    switch (areaType) {
      case 1:
        return MainAreaOrder(order_id: order_id);
      case 2:
        return MainAreaPending(selectedUsername: order_id);
      case 3:
        return MainAreaHistory(selectedUsername: order_id,); // Placeholder container
      default:
        return Container(); // Placeholder container
    }
  }
}

class MainAreaOrder extends StatelessWidget {
  final String order_id;
  const MainAreaOrder({Key? key, required this.order_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ShowOrderPageTablet(order_id: order_id);
    // return ShowOrderPageTablet(username: selectedUsername);
  }
}

class MainAreaPending extends StatelessWidget {
  final String selectedUsername;
  const MainAreaPending({Key? key, required this.selectedUsername}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowPendingPageTablet(username: selectedUsername);
  }
}

class MainAreaHistory extends StatelessWidget {
  final String selectedUsername;
  const MainAreaHistory({Key? key, required this.selectedUsername}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowHistoryPageTablet(username: selectedUsername);
  }
}


