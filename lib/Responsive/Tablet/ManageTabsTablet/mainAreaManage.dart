import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/ManageTab/ShopStatus.dart';
import 'package:fypmerchant/Responsive/Tablet/ManageTabsTablet/StockManage/StockManageTablet.dart';

class MainAreaManage extends StatelessWidget {
  final int type;
  const MainAreaManage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: areaWidget(),
    );
  }
  Widget areaWidget(){
    switch (type){
      case 1:
        return const ShopStatusManage();
      case 2:
        return const ManageStockPage();
      default:
        return const ShopStatusManage();
    }
  }
}

