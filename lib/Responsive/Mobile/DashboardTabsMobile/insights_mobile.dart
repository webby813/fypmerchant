import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/DashboardTab/insightsRevenueInfo.dart';
import '../../../Color/color.dart';
import '../../Cross-platform code/DashboardTab/insights_chart.dart';

class InsightsMobile extends StatefulWidget {
  const InsightsMobile({super.key});

  @override
  State<InsightsMobile> createState() => _InsightsMobileState();
}

class _InsightsMobileState extends State<InsightsMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: const InsightsChart(),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
