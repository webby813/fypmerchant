import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/menu_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  String _selectedOption = 'Today'; // Default selected option
  List<String> options = ['Today', 'Yesterday', 'Weekly'];


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
                  items: options,
                  selectedItem: _selectedOption,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedOption = newValue;
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
            stream: _getStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final List<Widget> orderList = [];
                final docs = snapshot.data?.docs ?? [];
                for (var doc in docs) {
                  var orderId = doc['order_id'];
                  var paidTime = doc['paid_Time'];
                  var paidAmount = doc['paid_Amount'];

                  orderList.add(TransactionItems(
                    orderId: orderId,
                    paidTime: paidTime,
                    paidAmount: paidAmount,
                  ));
                }
                return ListView(
                  children: orderList,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Stream<QuerySnapshot> _getStream() {
    DateTime now = DateTime.now();
    DateTime startTime;
    DateTime endTime;

    switch (_selectedOption) {
      case 'Today':
        startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);
        endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'Yesterday':
        DateTime yesterday = now.subtract(const Duration(days: 1));
        startTime = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
        endTime = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case 'Weekly':
        DateTime monday = now.subtract(Duration(days: now.weekday - 1));
        DateTime sunday = monday.add(const Duration(days: 6));
        startTime = DateTime(monday.year, monday.month, monday.day, 0, 0, 0);
        endTime = DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
        break;
      default:
        startTime = now;
        endTime = now;
    }

    return FirebaseFirestore.instance
        .collection('Orders')
        .where("paid_Time", isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
        .where("paid_Time", isLessThanOrEqualTo: Timestamp.fromDate(endTime))
        .snapshots();
  }
}

class TransactionItems extends StatelessWidget {
  final String orderId;
  final Timestamp paidTime;
  final double paidAmount;

  const TransactionItems({
    Key? key,
    required this.orderId,
    required this.paidTime,
    required this.paidAmount,
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
                      "Order#$orderId",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('dd MMM yyyy hh:mm a').format(paidTime.toDate()),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "RM$paidAmount",
                    style: const TextStyle(
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

