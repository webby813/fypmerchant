import 'package:fypmerchant/Components/cart_widget.dart';
import 'package:flutter/material.dart';

class ReceiveOrderMobile extends StatefulWidget {
  const ReceiveOrderMobile({Key? key}) : super(key: key);

  @override
  State<ReceiveOrderMobile> createState() => _ReceiveOrderMobileState();
}

class _ReceiveOrderMobileState extends State<ReceiveOrderMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ViewOrder(),
          ],
        )
      )
    );
  }
}


