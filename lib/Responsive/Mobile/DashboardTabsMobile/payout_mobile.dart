import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Cross-platform%20code/DashboardTab/insightsRevenueInfo.dart';
import '../../../Color/color.dart';
import '../../Cross-platform code/DashboardTab/payout_withdraw.dart';
import '../../Cross-platform code/DashboardTab/payout_transaction.dart';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              color: CustomColors.defaultWhite,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: AvailableBalanceInfo()
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Transaction'),
              Tab(text: 'Withdraw'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Transaction(),
                Withdraw(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

