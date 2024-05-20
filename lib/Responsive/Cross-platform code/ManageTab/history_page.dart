import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/menu_widget.dart';
import 'package:fypmerchant/Components/spinner_widget.dart';
import 'package:fypmerchant/Components/textTitle_widget.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<String> itemsList = ["Today", "Last 3 days", "Last Week"];
  String? selectedItem;
  Stream<QuerySnapshot> stream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    selectedItem = itemsList[0];
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    DateTime now = DateTime.now();
    DateTime startTime;
    DateTime endTime = now;

    if (selectedItem == "Today") {
      startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);
      endTime = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (selectedItem == "Last 3 days") {
      startTime = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 3));
    } else if (selectedItem == "Last Week") {
      startTime = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
    } else {
      startTime = now;
    }

    setState(() {
      stream = FirebaseFirestore.instance
          .collection('Orders')
          .where("order_Status", isEqualTo: "Finished")
          .where("paid_Time", isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
          .where("paid_Time", isLessThanOrEqualTo: Timestamp.fromDate(endTime))
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
                width: 140,
                child: CustomDropdown(
                  items: itemsList,
                  selectedItem: selectedItem,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedItem = newValue;
                      _initializeStream(); // Re-initialize the stream with the new filter
                    });
                  },
                ),
              ),
              StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Spinner.loadingSpinner();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final List<Widget> orderList = [];
                    final docs = snapshot.data?.docs ?? [];
                    for (var doc in docs) {
                      var orderId = doc['order_id'];
                      var orderDate = doc['paid_Time'];

                      orderList.add(
                        HistoryCard(
                          orderId: orderId,
                          orderDate: orderDate,
                        ),
                      );
                    }
                    return Column(
                      children: orderList,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryCard extends StatefulWidget {
  final String orderId;
  final Timestamp orderDate; // Change this to Timestamp

  const HistoryCard({Key? key, required this.orderId, required this.orderDate}) : super(key: key);

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  String _formattedDate = '';

  @override
  void initState() {
    super.initState();
    _formattedDate = _formatDate(widget.orderDate.toDate());
  }
  String _formatDate(DateTime dateTime) {
    try {
      DateFormat desiredFormat = DateFormat("d MMM yyyy");
      return desiredFormat.format(dateTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: SizedBox(
            width: constraints.maxWidth,
            child: Card(
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 6,
                        child: OrderTitle.orderTitle(widget.orderId, 15, FontWeight.w800),
                      ),
                      Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Spacer(), // 保持在右侧的空间
                            OrderTitle.orderTitle(_formattedDate, 15, FontWeight.w800),
                          ],
                        ),
                      ),
                    ],
                  ),

                  trailing: const SizedBox.shrink(),
                  children: const <Widget>[
                    ///Retrieve History ItemCard
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HistoryItemCard extends StatefulWidget {
  final String orderId;
  const HistoryItemCard({Key? key, required this.orderId}) : super(key: key);

  @override
  State<HistoryItemCard> createState() => _HistoryItemCardState();
}

class _HistoryItemCardState extends State<HistoryItemCard> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

