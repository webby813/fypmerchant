import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/container_widget.dart';

class MainAreaStockManage extends StatefulWidget {
  final String category;

  const MainAreaStockManage({Key? key, required this.category})
      : super(key: key);

  @override
  _MainAreaStockManageState createState() => _MainAreaStockManageState();
}

class _MainAreaStockManageState extends State<MainAreaStockManage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CustomColors.defaultWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Widget in container_widget.dart, StockItemCard
            StockItemCard(name: "name", price: "price", description: "description"),
            StockItemCard(name: "name", price: "price", description: "description"),
            StockItemCard(name: "name", price: "price", description: "description"),
          ],
        )
      ),
    );
  }
}
