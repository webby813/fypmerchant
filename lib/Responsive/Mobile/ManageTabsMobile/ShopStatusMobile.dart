import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/ManageTab/ShopStatus.dart';

import '../../../Color/color.dart';
import '../../../Components/barTitle_widget.dart';

class ShopStatusMobile extends StatefulWidget {
  const ShopStatusMobile({super.key});

  @override
  State<ShopStatusMobile> createState() => _ShopStatusMobileState();
}

class _ShopStatusMobileState extends State<ShopStatusMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.defaultWhite,
        title: BarTitle.appBarText('Shop Status'),
        elevation: 0,
      ),
      body: ShopStatusManage(),
    );
  }
}
