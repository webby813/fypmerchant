import 'package:fypmerchant/Components/cart_widget.dart';
import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ViewOrder(),
          ],
        )
      )
    );
  }
}


