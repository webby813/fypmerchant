import 'package:flutter/material.dart';
import 'package:fypmerchant/Firebase/pending_order.dart';
import 'package:fypmerchant/Responsive/Mobile/OrderTabsMobile/HistoryOrderMobile.dart';
import '../../../Firebase/history_order.dart';
import '../../../Firebase/view_order.dart';

class MainArea extends StatelessWidget {
  final String selectedUsername;
  final int areaType;

  const MainArea({
    Key? key,
    required this.selectedUsername,
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
        return MainAreaOrder(selectedUsername: selectedUsername);
      case 2:
        return MainAreaPending(selectedUsername: selectedUsername);
      case 3:
        return MainAreaHistory(selectedUsername: selectedUsername,); // Placeholder container
      default:
        return Container(); // Placeholder container
    }
  }
}

class MainAreaOrder extends StatelessWidget {
  final String selectedUsername;
  const MainAreaOrder({Key? key, required this.selectedUsername}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowOrderPageTablet(username: selectedUsername);
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


