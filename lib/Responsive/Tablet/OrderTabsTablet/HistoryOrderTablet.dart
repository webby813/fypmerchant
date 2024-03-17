import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Firebase/history_order.dart';

class HistoryOrderTablet extends StatefulWidget {
  final Function(String?) onCardTap;
  const HistoryOrderTablet({super.key, required this.onCardTap});

  @override
  State<HistoryOrderTablet> createState() => _HistoryOrderTabletState();
}

class _HistoryOrderTabletState extends State<HistoryOrderTablet> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('History');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewHistoryOrderTablet(onCardTap: widget.onCardTap),
    );
  }
  void dispose() {
    widget.onCardTap(null);
    super.dispose();
  }
}
