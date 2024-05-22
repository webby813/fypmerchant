import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fypmerchant/Components/menu_widget.dart';
import 'package:intl/intl.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({Key? key}) : super(key: key);

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  String _selectedMonth = '';
  List<String> recentMonths = [];

  @override
  void initState() {
    super.initState();
    _initializeRecentMonths();
  }

  void _initializeRecentMonths() {
    DateTime now = DateTime.now();
    for (int i = 2; i >= 0; i--) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      recentMonths.add(DateFormat('MMMM').format(month));
    }
    _selectedMonth = DateFormat('MMMM').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CustomDropdown(
                  items: recentMonths,
                  selectedItem: _selectedMonth,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedMonth = newValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _getWithdrawRecordsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No records found for the selected month.'));
              } else {
                final List<Widget> withdrawList = [];
                final docs = snapshot.data?.docs ?? [];
                for (var doc in docs) {
                  var withdrawAmount = doc['withdraw_Amount'];
                  var withdrawTime = (doc['withdraw_time'] as Timestamp).toDate();

                  withdrawList.add(WithdrawRecord(
                    withdrawAmount: withdrawAmount,
                    withdrawTime: withdrawTime,
                  ));
                }
                return ListView(
                  children: withdrawList,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Stream<QuerySnapshot> _getWithdrawRecordsStream() {
    DateTime now = DateTime.now();
    int selectedMonthIndex = recentMonths.indexOf(_selectedMonth);

    DateTime selectedDate = DateTime(now.year, now.month - 2 + selectedMonthIndex, 1);
    DateTime startTime = DateTime(selectedDate.year, selectedDate.month, 1);
    DateTime endTime = DateTime(selectedDate.year, selectedDate.month + 1, 1).subtract(const Duration(seconds: 1));

    return FirebaseFirestore.instance
        .collection('merchant')
        .doc('Merchant')
        .collection('withdrawals')
        .where("withdraw_time", isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
        .where("withdraw_time", isLessThanOrEqualTo: Timestamp.fromDate(endTime))
        .snapshots();
  }
}

class WithdrawRecord extends StatelessWidget {
  final double withdrawAmount;
  final DateTime withdrawTime;

  const WithdrawRecord({
    Key? key,
    required this.withdrawAmount,
    required this.withdrawTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: CustomColors.lightGrey,
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      DateFormat('dd MMM yyyy at HH:mm:ss').format(withdrawTime),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "- RM${withdrawAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: CustomColors.warningRed,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}