import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';

class InsightsTablet extends StatefulWidget {
  const InsightsTablet({super.key});

  @override
  State<InsightsTablet> createState() => _InsightsTabletState();
}

class _InsightsTabletState extends State<InsightsTablet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18,10,20,18),
          child: Center(
            child: SizedBox(
              height: 400,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center, // Center the text within the Card
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align Row contents horizontally to center
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
                ],
              ),
            ),
          ),
        )
    );
  }
}
