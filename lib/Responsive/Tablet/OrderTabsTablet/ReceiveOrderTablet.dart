import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../Firebase/view_order.dart';

class ReceiveOrderTablet extends StatefulWidget {
  final Function(String?) onCardTap;
  const ReceiveOrderTablet({Key? key, required this.onCardTap}) : super(key: key);

  @override
  State<ReceiveOrderTablet> createState() => _ReceiveOrderTabletState();
}

class _ReceiveOrderTabletState extends State<ReceiveOrderTablet> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('Order');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ViewOrderTablet(onCardTap: widget.onCardTap),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    widget.onCardTap(null);
    super.dispose();
  }
}

