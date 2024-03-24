import 'package:flutter/material.dart';
import '../../../Color/color.dart';
import '../../Cross-platform code/Payout_Settlement.dart';
import '../../Cross-platform code/Payout_Transaction.dart';

class PayoutMobile extends StatefulWidget {
  const PayoutMobile({Key? key}) : super(key: key);

  @override
  State<PayoutMobile> createState() => _PayoutMobileState();
}

class _PayoutMobileState extends State<PayoutMobile> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.lightGrey,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              color: CustomColors.defaultWhite,
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.exit_to_app_outlined),
                      iconSize: 35,
                    ),
                  ],
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Transaction'),
              Tab(text: 'Settlement'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Transaction(),
                Settlement(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

