import 'package:flutter/material.dart';
import 'package:fypmerchant/Firebase/pending_order.dart';
import '../../../Firebase/view_order.dart';

class MainArea extends StatefulWidget {
  final String selectedUsername;
  final int areaType;

  const MainArea({
    Key? key,
    required this.selectedUsername,
    required this.areaType,
  }) : super(key: key);

  @override
  State<MainArea> createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  Widget areaWidget() {
    switch (widget.areaType) {
      case 1:
        return MainAreaOrder(selectedUsername: widget.selectedUsername);
      case 2:
      // Handle case 2
        return MainAreaPending(selectedUsername: widget.selectedUsername);
      case 3:
      // Handle case 3
        return Container(); // Placeholder container
      default:
      // Handle default case
        return Container(); // Placeholder container
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: areaWidget(),
      ),
    );
  }
}



class MainAreaOrder extends StatefulWidget {
  final String selectedUsername;
  const MainAreaOrder({super.key, required this.selectedUsername});

  @override
  State<MainAreaOrder> createState() => _MainAreaOrderState();
}

class _MainAreaOrderState extends State<MainAreaOrder> {
  @override
  Widget build(BuildContext context) {
    return ShowOrderPageTablet(username: widget.selectedUsername);
  }
}

class MainAreaPending extends StatefulWidget {
  final String selectedUsername;
  const MainAreaPending({super.key, required this.selectedUsername});

  @override
  State<MainAreaPending> createState() => _MainAreaPendingState();
}

class _MainAreaPendingState extends State<MainAreaPending> {
  @override
  Widget build(BuildContext context) {
    return ShowPendingPageTablet(username: widget.selectedUsername);
  }
}

