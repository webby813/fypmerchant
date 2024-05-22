import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/DashboardTab/insightsRevenueInfo.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/DashboardTab/payout_withdraw.dart';
import '../../Cross-platform code/DashboardTab/payout_transaction.dart';


class PayoutTablet extends StatefulWidget {
  const PayoutTablet({Key? key}) : super(key: key);

  @override
  State<PayoutTablet> createState() => _PayoutTabletState();
}

class _PayoutTabletState extends State<PayoutTablet> {

  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.lightGrey,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Column(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(200, 5, 200, 10),
                      child: AvailableBalanceInfo()
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  color: CustomColors.defaultWhite,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 5),
                              child: Text(
                                "Transactions",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Transaction(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 5),
                              child: Text(
                                "Withdraw Record",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,),
                              ),
                            ),
                            Expanded(
                              child: Withdraw(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}