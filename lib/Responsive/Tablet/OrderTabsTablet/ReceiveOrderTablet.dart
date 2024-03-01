import 'dart:math';

import 'package:flutter/material.dart';

import '../../../Components/cart_widget.dart';

class ReceiveOrderTablet extends StatefulWidget {
  const ReceiveOrderTablet({super.key});

  @override
  State<ReceiveOrderTablet> createState() => _ReceiveOrderTabletState();
}

class _ReceiveOrderTabletState extends State<ReceiveOrderTablet> {
  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                ViewOrder(maxWidth: maxWidth),
              ],
            )
        )
    );
  }
}
