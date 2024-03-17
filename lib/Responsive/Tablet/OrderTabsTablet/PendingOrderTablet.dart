import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../Firebase/pending_order.dart';

class PendingOrderTablet extends StatefulWidget {
  final Function(String?) onCardTap;
  const PendingOrderTablet({super.key, required this.onCardTap});

  @override
  State<PendingOrderTablet> createState() => _PendingOrderTabletState();
}

class _PendingOrderTabletState extends State<PendingOrderTablet> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('Pending');

  String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              ViewPendingOrderTablet(onCardTap: widget.onCardTap)
            ],
          ),
        )
    );
  }
}
