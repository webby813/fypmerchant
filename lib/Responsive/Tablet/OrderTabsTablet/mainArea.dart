import 'package:flutter/material.dart';
import 'package:fypmerchant/Firebase/pending_order.dart';
import '../../../Firebase/view_order.dart';

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

// class MainAreaPending extends StatefulWidget {
//   const MainAreaPending({super.key});
//
//   @override
//   State<MainAreaPending> createState() => _MainAreaPendingState();
// }
//
// class _MainAreaPendingState extends State<MainAreaPending> {
//   @override
//   Widget build(BuildContext context) {
//     return ShowPendingPageTablet(username: )
//   }
// }

