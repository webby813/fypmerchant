import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/divider_widget.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/Payout_Settlement.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/Payout_Transaction.dart';

class PayoutTablet extends StatefulWidget {
  const PayoutTablet({Key? key}) : super(key: key);

  @override
  State<PayoutTablet> createState() => _PayoutTabletState();
}

class _PayoutTabletState extends State<PayoutTablet> {
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
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(200, 5, 200, 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          color: CustomColors.defaultWhite,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Available Balance",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),

                                    const SizedBox(height: 16),

                                    Center(
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'RM ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: CustomColors.defaultBlack,
                                                fontSize: 24,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '23,980.78',
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: CustomColors.indigo,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20), // Adjust the width here to increase or decrease space
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.exit_to_app_outlined),
                                iconSize: 35, // Set the size of the icon
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 6),
                ],
              ),
              // Second Container for Transactions and Settlement
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
                            Text(
                              "Transactions",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            DivideWidget(),
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
                            Text(
                              "Settlement",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,                              ),
                            ),
                            DivideWidget(),

                            Expanded(
                              child: Settlement(),
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

