import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
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
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: CustomColors.defaultWhite,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Today's Revenue",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Orders\n876",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Revenue\nRM 56.98",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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