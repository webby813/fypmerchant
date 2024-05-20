import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/ManageTab/history_page.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/ManageTab/shop_status.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/ManageTab/support_pages.dart';

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
        return OrderHistory();
      case 3:
        ///Page stored in Cross-platform code
        return const HelpCentre();
      case 4:
      ///Page stored in Cross-platform code
        return const FeedbackPage();
      default:
        return const ShopStatusManage();
    }
  }
}

