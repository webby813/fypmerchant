import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/textTitle_widget.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/ManageTab/history_page.dart';


class HistoryPageMobile extends StatefulWidget {
  const HistoryPageMobile({super.key});

  @override
  State<HistoryPageMobile> createState() => _HistoryPageMobileState();
}

class _HistoryPageMobileState extends State<HistoryPageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.defaultWhite,
        title: AppBarWidget.bartext('History'),
        elevation: 0,
      ),
      body:const OrderHistory(),
    );
  }
}
