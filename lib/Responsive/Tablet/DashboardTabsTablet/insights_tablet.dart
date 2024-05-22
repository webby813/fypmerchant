import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/DashboardTab/insightsRevenueInfo.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/DashboardTab/insights_chart.dart';

class InsightsTablet extends StatefulWidget {
  const InsightsTablet({Key? key}) : super(key: key);

  @override
  State<InsightsTablet> createState() => _InsightsTabletState();
}

class _InsightsTabletState extends State<InsightsTablet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.lightGrey,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 20, 18),
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height, // Use MediaQuery to get screen height
                width: 500,
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      color: CustomColors.defaultWhite,
                      child: RevenueInfo(),
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      color: CustomColors.defaultWhite,
                      child: InsightsChart(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}


