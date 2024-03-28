import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/ManageTab/ShopStatus.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/supportingPage.dart';

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
        // return const ManageStockPage();
      case 3:
        return const HelpCentre();
      case 4:
        return const FeedbackPage();
      default:
        return const ShopStatusManage();
    }
  }
}

