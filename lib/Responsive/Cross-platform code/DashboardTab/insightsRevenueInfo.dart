import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/spinner_widget.dart';
import 'package:fypmerchant/Firebase/retrieve_data.dart';
import 'package:fypmerchant/Firebase/update_data.dart';

class RevenueInfo extends StatefulWidget {
  const RevenueInfo({super.key});

  @override
  State<RevenueInfo> createState() => _RevenueInfoState();
}

class _RevenueInfoState extends State<RevenueInfo> {
  int orderCount = 0;
  double totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchTodayRevenue();
  }

  Future<void> _fetchTodayRevenue() async {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .where("order_Status", isEqualTo: "Finished")
        .where("paid_Time", isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
        .where("paid_Time", isLessThanOrEqualTo: Timestamp.fromDate(endTime))
        .get();

    int count = snapshot.docs.length;
    double revenue = 0.0;

    for (var doc in snapshot.docs) {
      revenue += doc['paid_Amount'];
    }

    setState(() {
      orderCount = count;
      totalRevenue = revenue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Today's Revenue",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Orders\n$orderCount",
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Revenue\nRM ${totalRevenue.toStringAsFixed(2)}",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AvailableBalanceInfo extends StatefulWidget {
  const AvailableBalanceInfo({super.key});

  @override
  State<AvailableBalanceInfo> createState() => _AvailableBalanceInfoState();
}

class _AvailableBalanceInfoState extends State<AvailableBalanceInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<double>(

        stream: RetrieveData().getWalletBalance(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Spinner.loadingSpinner();
          }
          if(snapshot.hasError){
            return const Text('error');
          }
          double balance = snapshot.data ??  0.0;
          return Padding(
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
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'RM ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.defaultBlack,
                                  fontSize: 24,
                                ),
                              ),
                              TextSpan(
                                text: balance.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 35,
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
                  onPressed: () {
                    UpdateData().withdrawBalance(context);
                  },
                  icon:  Image.asset(
                    'lib/Components/withdraw.png',
                    width: 80,
                    height: 80,
                  ),
                  iconSize: 35, // Set the size of the icon
                ),

              ],
            ),
          );
        },
      )
    );
  }
}

